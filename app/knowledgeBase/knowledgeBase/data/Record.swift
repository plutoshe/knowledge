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

class RecordItem: Codable {
    var RecordID: String = ""
    var Front: [Content] = []
    var Back: [Content] = []
    var CreateDate: Int64 = 0
    var ReviewDate: Int64 = 0
    var RemeberDate: Int64 = 0
    var Tags: [String] = []
    var Reminder: Int = 0
}
