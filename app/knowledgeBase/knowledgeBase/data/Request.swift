//
//  RequestBody.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/8.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Foundation

let DefaultRecordURL = "http://127.0.0.1:16759/record"
let DefaultReviewURL = "http://127.0.0.1:16759/review"

func TrimToLocalDay(fromDate: Date) -> Int {
    let gregorian = Calendar(identifier: .gregorian)
    var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate)
    // Change the time to 9:30:00 in your locale
    components.hour = 0
    components.minute = 0
    components.second = 0
    return Int(gregorian.date(from: components)!.timeIntervalSince1970)
}

class RecordPostRequestBody: Codable {
    var FrontContent : [Content] = []
    var BackContent: [Content] = []
    var Tags: [String] = []
    var CreateDate: Int = 0
    var ReviewDate: Int = 0
    var RememberDate: Int = 0
    
    init() {}
    init(FrontContent: [Content], BackContent: [Content]) {
        self.FrontContent = FrontContent
        self.BackContent = BackContent
        self.CreateDate = Int(Date().timeIntervalSince1970)
        self.RememberDate = TrimToLocalDay(fromDate: Date(timeIntervalSince1970: TimeInterval(self.CreateDate)))
        self.ReviewDate = Int(Calendar.current.date(byAdding: .day, value: 1, to: Date(timeIntervalSince1970:TimeInterval(self.RememberDate)))!.timeIntervalSince1970)
    }
}

typealias RecordPutRequestBody = RecordPostRequestBody

class ReviewGetRequestBody: Codable {
    var HasTag : Int = 0
    var Tags : [String] = []
    var ReviewDate : Int = 0
    var RememberDate : Int = 0
    init() {}
    init(ReviewDate: Int) {
        self.ReviewDate = ReviewDate
        self.RememberDate = TrimToLocalDay(fromDate: Date(timeIntervalSince1970: TimeInterval(self.ReviewDate)))
        self.HasTag = 0
    }
}

class ReviewGetResponseBody: Codable {
    var ReviewedRecord: [RecordItem] = []
    var UnReviewedRecord: [RecordItem] = []
}

class ReviewPutRequestBody: Codable {
    var RecordID: String = ""
    var RememberDate: Int = 0
    var ReviewDate: Int = 0
    var CurrentReviewStatus: Int = 0

    init() {}
    init(RecordID: String, RememberDate: Int, ReviewDate: Int, CurrentReviewStatus: Int) {
        self.RecordID = RecordID
        self.RememberDate = RememberDate
        self.ReviewDate = ReviewDate
        self.CurrentReviewStatus = CurrentReviewStatus
    }
}

class RecordRequest {
    private var POSTDataTask: URLSessionDataTask? = nil
    private var PUTDataTask: URLSessionDataTask? = nil
    private let defaultSession = URLSession.shared
    var RecordURL = DefaultRecordURL
    init() {}
    
    func POSTRequest(recordPOSTRequstBody: RecordPostRequestBody, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let jsonEncoder = JSONEncoder()
        let RecordPOSTJSON = try? jsonEncoder.encode(recordPOSTRequstBody)
        
        let RecordPOSTURL = URL(string: RecordURL)
        var request : URLRequest = URLRequest(url: RecordPOSTURL!)
        request.httpMethod = "POST"

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = RecordPOSTJSON
        
        POSTDataTask = defaultSession.dataTask(with: request, completionHandler: completionHandler)
        POSTDataTask!.resume()
    }
    
    func PUTRequest(recordPUTRequstBody: RecordPutRequestBody, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let jsonEncoder = JSONEncoder()
        let RecordPUTJSON = try? jsonEncoder.encode(recordPUTRequstBody)
        
        let RecordPUTURL = URL(string: RecordURL)
        var request : URLRequest = URLRequest(url: RecordPUTURL!)
        request.httpMethod = "PUT"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = RecordPUTJSON
        
        PUTDataTask = defaultSession.dataTask(with: request, completionHandler: completionHandler)
        PUTDataTask!.resume()
    }
    
}

class ReviewRequest {
    private var GETDataTask: URLSessionDataTask? = nil
    private var PUTDataTask: URLSessionDataTask? = nil
    private let defaultSession = URLSession.shared
    var ReviewURL = DefaultReviewURL
    
    init() {}
    
    func GETRequest(queryItems: [URLQueryItem], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let dataTask = GETDataTask {
            dataTask.cancel()
        }
        
        let urlComponents = NSURLComponents(string: ReviewURL)!
        urlComponents.queryItems = queryItems
        
        let ReviewGetURL = urlComponents.url
        var request : URLRequest = URLRequest(url: ReviewGetURL!)
        request.httpMethod = "POST" // currently, Get request has some errors when request, therefore use Post temporarily.
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        GETDataTask = defaultSession.dataTask(with: request, completionHandler: completionHandler)
        GETDataTask!.resume()
    }
    
    func PUTRequest(requestBody: ReviewPutRequestBody, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let jsonEncoder = JSONEncoder()
        let ReviewPUTRequestJSON = try? jsonEncoder.encode(requestBody)
        let ReviewPutURL = URL(string: ReviewURL)
        var request : URLRequest = URLRequest(url: ReviewPutURL!)
        
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = ReviewPUTRequestJSON
        
        PUTDataTask = defaultSession.dataTask(with: request, completionHandler: completionHandler)
        PUTDataTask!.resume()
    }
}

