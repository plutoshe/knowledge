//
//  ReviewViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/8.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewViewController: NSViewController {
    let defaultSession = URLSession.shared
    var DataTask: URLSessionDataTask? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func CheckResult(_ sender: Any) {
    }
    @IBAction func Remember(_ sender: Any) {
    }
    @IBAction func Forget(_ sender: Any) {
    }
    
    @IBAction func Refresh(_ sender: Any) {
        if let DataTask = DataTask {
            DataTask.cancel()
        }
        let ReviewGetRequestData = ReviewGetRequestBody(ReviewDate: Int(Date().timeIntervalSince1970))
        let jsonEncoder = JSONEncoder()
        let ReviewGetRequestJSON = try? jsonEncoder.encode(ReviewGetRequestData)
        print(String(data: ReviewGetRequestJSON!, encoding: String.Encoding.utf8)!)
        let urlComponents = NSURLComponents(string: ReviewURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "HasTag", value: String(ReviewGetRequestData.HasTag)),
            URLQueryItem(name: "Tags", value: ReviewGetRequestData.Tags.joined(separator: ",")),
            URLQueryItem(name: "ReviewDate", value: String(ReviewGetRequestData.ReviewDate)),
        ]
        let ReviewGetURL = urlComponents.url
        var request : URLRequest = URLRequest(url: ReviewGetURL!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = ReviewGetRequestJSON
        
        DataTask = defaultSession.dataTask(with: request)
        { (data, response, error) in
            defer { self.DataTask = nil }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8)!)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let jsonDecoder = JSONDecoder()
            print("!!!!")
            
//            do {
            if let recordItems = try? jsonDecoder.decode(ReviewGetResponseBody.self, from: data) {
                    
                print(recordItems)
//            } catch {
//                print(error)
            }
        }
        DataTask!.resume()
        
    }
}
