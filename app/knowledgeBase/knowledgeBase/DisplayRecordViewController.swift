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
    @IBOutlet weak var DisplayContent: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let displayRecord = DisplayRecord {
            self.DisplayContent.stringValue = displayRecord.Content(pageIndex: PageIndex.front) + "\n" + displayRecord.Content(pageIndex: PageIndex.back)
        }
    }
}
