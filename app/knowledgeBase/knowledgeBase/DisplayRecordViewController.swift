//
//  DisplayRecordViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/7/19.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class DisplayRecordViewController: NSViewController {
    var DisplayRecord : RecordItem?
    var recordRequests = RecordRequest()
    @IBOutlet weak var DisplayContent: NSTextField!
    
    @IBAction func ModifyRecord(_ sender: Any) {
        if let tabBarController = self.parent?.parent as? NSTabViewController {
            let recordViewController = tabBarController.childViewControllers[0] as! AdditionViewController
            recordViewController.CurrentRecord = self.DisplayRecord!
            recordViewController.mode = "PUT"
            recordViewController.BackTab = 2
            tabBarController.selectedTabViewItemIndex = 0
        }
    }
    
    @IBAction func UpdateRecordReviewData(_ sender: Any) {
        if let displayRecord = self.DisplayRecord {
            var currentDate = Int(TrimToLocalDay(fromDate: Date()))
            displayRecord.RememberDate = currentDate - (displayRecord.ReviewDate - displayRecord.RememberDate)
            displayRecord.ReviewDate = currentDate
            self.recordRequests.PUTRequest(recordPUTRequstBody: displayRecord) { data, response, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear() {
        if let displayRecord = DisplayRecord {
            self.DisplayContent.stringValue = displayRecord.Content(pageIndex: PageIndex.front) + "\n" + displayRecord.Content(pageIndex: PageIndex.back)
        }
    }
}
