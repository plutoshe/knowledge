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
    var BackTab = 0
    var mode = "POST"
    var recordRequests = RecordRequest()
    var CurrentRecord: RecordItem? = nil
    
    @IBOutlet weak var SubmitButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    

    override func viewWillAppear() {
        if mode == "PUT" {
            SubmitButton.title = "修改"
            if let currentRecord = self.CurrentRecord {
                self.FrontContent.stringValue = currentRecord.Front[0].Data
                self.BackContent.stringValue = currentRecord.Back[0].Data
            }
        } else {
            self.FrontContent.stringValue = ""
            self.BackContent.stringValue = ""
            SubmitButton.title = "添加"
        }
    }
    
    @IBAction func SubmitFromTextFieldThroughKeyShortcut(_ sender: Any) {
        
    }
    
    func AddRecord() {
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
    
    func ModifyRecord() {
        if self.CurrentRecord == nil {
            return
        }
        self.CurrentRecord!.Front = [Content(Form:"TEXT", Data:FrontContent.stringValue)]
        self.CurrentRecord!.Back = [Content(Form:"TEXT", Data:BackContent.stringValue)]
        
        
        recordRequests.PUTRequest(recordPUTRequstBody: self.CurrentRecord!) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            DispatchQueue.main.async {
                if let tabBarController = self.parent as? NSTabViewController {
                    tabBarController.selectedTabViewItemIndex = self.BackTab
                }
            }
        }
        
    }
    
    @IBAction func submitRecord(_ sender: Any) {
        if mode == "POST" {
            AddRecord()
        } else {
            ModifyRecord()
        }
    }
    
    override func viewWillDisappear() {
        mode = "POST"
        self.CurrentRecord = nil
    }
}
