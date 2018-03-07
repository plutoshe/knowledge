//
//  Record.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/2/23.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Foundation

class Content: Codable {
    var Form : String = ""
    var Data : String = ""
    init(Form: String, Data: String) {
        self.Form = Form
        self.Data = Data
    }
}

class AdditionBody: Codable {
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

class ReviewQueryBody: Codable {
    var HasTag : Int = 0
    var Tags : [Int] = []
    var ReviewDate : Int = 0
    init() {}
}

class ReviewUpdateBody: Codable {
}
}
