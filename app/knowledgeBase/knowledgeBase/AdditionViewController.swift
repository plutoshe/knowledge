//
//  AdditionViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/2/23.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class AdditionViewController: NSViewController {

    @IBOutlet weak var FrontContent: NSTextField!
    @IBOutlet weak var BackContent: NSTextField!
    var recordRequests = RecordRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func submitRecord(_ sender: Any) {
        let recordPostRequestData = RecordPostRequestBody(
            FrontContent: [Content(Form:"TEXT", Data:FrontContent.stringValue)],
            BackContent: [Content(Form:"TEXT", Data:BackContent.stringValue)]
        )
        
        recordRequests.POSTRequest(recordPOSTRequstBody: recordPostRequestData) { data, response, error in
            let myAlert = NSAlert()
            defer {
                DispatchQueue.main.async {
                    myAlert.runModal()
                }
            }
            guard error == nil else {
                print(error?.localizedDescription ?? "No data")
                myAlert.messageText = "Failed!"
                return
            }
            
            let jsonEncoder = JSONEncoder()
            let RecordPOSTJSON = try? jsonEncoder.encode(recordPostRequestData)
            
            myAlert.messageText = String(data: RecordPOSTJSON!, encoding: String.Encoding.utf8)!
        
        }
    }
}
