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
    var CurrentReviewStatus: Int = 0
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

extension Array {
    mutating func shuffle() {
        for _ in 0..<((count>0) ? (count-1) : 0) {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

class DisplayRecord {
    var mode: DisplayModeStatus = .UnReviewedRecord
    var RecordItems = [String: RecordItem]()
    var UnReviewedRecordCount: Int = 0
    var ReviewedRecordCount: Int = 0
    var ReviewOrderRemain: Int {
        get {
            return self.ReviewedOrder.count
        }
    }
    var ReviewedOrder: QueueBasedOnArray<String> = QueueBasedOnArray<String>()
    var currentReviewRecordID = ""
    
    var CurrentRecord: RecordItem? {
        get {
            if self.currentReviewRecordID == "" {
                return nil
            } else {
                return self.RecordItems[self.currentReviewRecordID]!
            }
        }
        set(newVal) {
            self.RecordItems[self.currentReviewRecordID] = newVal
        }
    }
    
    init() {
    }
    
    init(rs: ReviewGetResponseBody) {
        for element in rs.UnReviewedRecord {
            element.CurrentReviewStatus = 0
            self.RecordItems[element.RecordID] = element
        }
        for element in rs.ReviewedRecord {
            self.RecordItems[element.RecordID] = element
        }
        RefreshReviewOrder()
    }
    
    
    func ChangeCurrentRecordStatus(status: DisplayModeStatus) {
        if mode == DisplayModeStatus.UnReviewedRecord {
            self.ReviewedRecordCount += 1
            self.UnReviewedRecordCount -= 1
        } else {
            self.ReviewedRecordCount -= 1
            self.UnReviewedRecordCount += 1
        }
        
    }
    
    func clear() {
        self.RecordItems.removeAll()
        self.ReviewedRecordCount = 0
        self.UnReviewedRecordCount = 0
    }
    
    func PrintAll() {
        print("record ", self.RecordItems)
    }
    
    func reversedMode() -> DisplayModeStatus {
        switch mode {
        case .ReviewedRecord:
            return DisplayModeStatus.UnReviewedRecord
        case .UnReviewedRecord:
            return DisplayModeStatus.ReviewedRecord
        }
    }
    
    func ToggleMode() {
        mode = self.reversedMode()
        self.RefreshReviewOrder()
    }
    
    func RefreshReviewOrder() {
        self.ReviewedOrder.removeAll()
        self.UnReviewedRecordCount = 0
        self.ReviewedRecordCount = 0
        var reviewOrderArray : [String] = []
        for (_, element) in self.RecordItems {
            if element.CurrentReviewStatus == 0 {
                self.UnReviewedRecordCount+=1
            } else {
                self.ReviewedRecordCount+=1
            }
            if (self.mode == DisplayModeStatus.UnReviewedRecord && element.CurrentReviewStatus == 0) ||
               (self.mode == DisplayModeStatus.ReviewedRecord && element.CurrentReviewStatus == 1) {
                reviewOrderArray.append(element.RecordID)
            }
        }
        
        // shuffle the order array
        reviewOrderArray.shuffle()
        print("count: ", reviewOrderArray.count)
        for element in reviewOrderArray {
            self.ReviewedOrder.append(value: element)
        }
        
        if let currentRecordID = self.ReviewedOrder.peek() {
            self.currentReviewRecordID = currentRecordID
        } else {
            self.currentReviewRecordID = ""
        }
    }
    
    func RemoveCurrentReviewedItem() {
        if let currentRecord = self.CurrentRecord {
            if currentRecord.CurrentReviewStatus == 0 {
                ChangeCurrentRecordStatus(status: DisplayModeStatus.UnReviewedRecord)
            } else {
                ChangeCurrentRecordStatus(status: DisplayModeStatus.ReviewedRecord)
            }
        }
        self.ReviewedOrder.removeHead()
        if let currentRecordID = self.ReviewedOrder.peek() {
            self.currentReviewRecordID = currentRecordID
        } else {
            self.currentReviewRecordID = ""
        }
    }
    
    func ReoloadCurrentReviewedItem() {
        self.ReviewedOrder.relocateHead()
        self.currentReviewRecordID = self.ReviewedOrder.peek()!
    }
    
    func recordSize(requestMode: DisplayModeStatus) -> Int {
        switch requestMode {
        case .ReviewedRecord:
            return ReviewedRecordCount
        case .UnReviewedRecord:
            return UnReviewedRecordCount
        }
    }
}

