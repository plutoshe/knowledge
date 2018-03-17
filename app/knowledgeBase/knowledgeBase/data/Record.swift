//
//  Record.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/2/23.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Foundation

enum PageIndex: Int {
    case front = 0, back = 1
    mutating func toggle() {
        switch self {
        case .front:
            self = .back
        case .back:
            self = .front
        }
    }
}

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
    var CreateDate: Int = 0
    var ReviewDate: Int = 0
    var RememberDate: Int = 0
    var Tags: [String] = []
    var Reminder: Int = 0
    func Content(pageIndex: PageIndex) -> String {
        var result = ""
        if pageIndex == PageIndex.front {
            for element in self.Front {
                result += element.Data + "\n"
            }
        } else {
            for element in self.Back {
                result += element.Data + "\n"
            }
        }
        return result
    }
}

enum DisplayModeStatus: Int{
    case ReviewedRecord = 0, UnReviewedRecord
}

class DisplayRecord {
    var RecordItems = [DisplayModeStatus: [RecordItem]]()
    var Status = RecordStatus()
    var CurrentRecord: RecordItem { get {
            return self.RecordItems[self.Status.mode]![self.Status.displayItem]
        }
        set(newVal) {
            self.RecordItems[self.Status.mode]![self.Status.displayItem] = newVal
        }
    }
    init() {
        self.RecordItems[DisplayModeStatus.ReviewedRecord] = []
        self.RecordItems[DisplayModeStatus.UnReviewedRecord] = []
    }
    init(rs: ReviewGetResponseBody) {
        self.RecordItems[DisplayModeStatus.ReviewedRecord] = rs.ReviewedRecord
        self.RecordItems[DisplayModeStatus.UnReviewedRecord] = rs.UnReviewedRecord
    }
    
    func clear() {
        self.RecordItems.removeAll()
        self.Status.clear()
    }
    
    func PrintAll() {
        print("record ", self.RecordItems)
        print("mode", self.Status.mode)
        print("display_item", self.Status.displayItem)
    }
}

class RecordStatus {
    var mode: DisplayModeStatus = .UnReviewedRecord
    var displayItem: Int = -1

    init() {}
    func ToggleMode() {
        mode = reversedMode()
    }
    func clear() {
        self.mode = .UnReviewedRecord
        self.displayItem = -1
    }
    func reversedMode() -> DisplayModeStatus {
        switch mode {
        case .ReviewedRecord:
            return DisplayModeStatus.UnReviewedRecord
        case .UnReviewedRecord:
            return DisplayModeStatus.ReviewedRecord
        }
    }
   
}

