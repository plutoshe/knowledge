//
//  RequestBody.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/8.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Foundation

let AdditionURL = "http://127.0.0.1:16759/record"
let ReviewURL = "http://127.0.0.1:16759/review"

class AdditionPostRequestBody: Codable {
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
        let createDate = Date()
        self.CreateDate = Int(createDate.timeIntervalSince1970)
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate)
        // Change the time to 9:30:00 in your locale
        components.hour = 0
        components.minute = 0
        components.second = 0
        self.RememberDate = Int(gregorian.date(from: components)!.timeIntervalSince1970)
        self.ReviewDate = Int(Calendar.current.date(byAdding: .day, value: 1, to: gregorian.date(from: components)!)!.timeIntervalSince1970)
    }
}

class ReviewGetRequestBody: Codable {
    var HasTag : Int = 0
    var Tags : [String] = []
    var ReviewDate : Int = 0
    init() {}
    init (ReviewDate: Int) {
        self.ReviewDate = ReviewDate
        self.HasTag = 0
    }
}

class ReviewGetResponseBody: Codable {
    var ReviewedRecord: [RecordItem] = []
    var UnReviewedRecord: [RecordItem] = []
}

class ReviewPutRequestBody: Codable {
    var RecordID: String = ""
    var ReviewDate: Int = 0
    var RememberDate: Int = 0
    init() {}
}
