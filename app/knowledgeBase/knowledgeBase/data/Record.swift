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
    var RememberDate: Int64 = 0
    var Tags: [String] = []
    var Reminder: Int = 0
}
enum DisplayModeStatus: Int{
    case ReviewedRecord = 0, UnReviewedRecord
}
class DisplayRecord {
    var RecordItems = [DisplayModeStatus: [RecordItem]]()
    func GetCurrentStatusRecord(display:DisplayRecordStatus) -> RecordItem {
        return self.RecordItems[display.mode]![display.displayItem]
    }
    init(rs: ReviewGetResponseBody) {
        self.RecordItems[DisplayModeStatus.ReviewedRecord] = rs.ReviewedRecord
        self.RecordItems[DisplayModeStatus.UnReviewedRecord] = rs.UnReviewedRecord
    }
}

class DisplayRecordStatus {
    var mode: DisplayModeStatus = .UnReviewedRecord
    var displayItem: Int = -1
    init() {}
    func ToggleMode() {
        switch mode {
            case .ReviewedRecord:
            mode = .UnReviewedRecord
            case .UnReviewedRecord:
            mode = .ReviewedRecord
        }
    }
}

