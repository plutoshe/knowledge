//
//  RecordQueryViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/6/19.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class RecordQueryViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //self.tableView.reloadData()
    }
    var recordRequests = RecordRequest()
    
    
    @IBOutlet weak var RetrievedData: NSScrollView!
    @IBOutlet weak var SearchKeyword: NSTextField!
    @IBAction func Search(_ sender: NSButton) {
        print("=========+")
        recordRequests.GETRequest(recordGetRequestBody: RecordGetRequestBody(Keyword: SearchKeyword.stringValue)) { data, response, error in
//            RetrievedData.
        }
        
        
    }
}
