//
//  DisplaySearchRecordController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/7/19.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class DisplaySearchRecordViewController: NSViewController {
    var CheckDetailFromParent: ((RecordItem) ->())?
    var SearchText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func CheckDetail(_ sender: Any) {
        var a = RecordItem()
        let b = Content(Form: "TEXT", Data: "test")
        a.Front.append(b)
        print(CheckDetailFromParent!)
        CheckDetailFromParent!(a)
    }
}
