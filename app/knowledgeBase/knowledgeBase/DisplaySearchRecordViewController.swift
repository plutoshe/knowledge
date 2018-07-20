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
    var recordRequests = RecordRequest()
    var tableViewData: [RecordItem] = []
    
    @IBOutlet weak var SearchRecordTable: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchRecordTable.delegate = self as? NSTableViewDelegate
        self.SearchRecordTable.dataSource = self
        self.SearchRecordTable.target = self
        self.SearchRecordTable.doubleAction = #selector(tableViewDoubleClick(_:))
        // Do view setup here.
        
    }
    
    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        if self.SearchRecordTable.selectedRow >= 0 {
            CheckDetailFromParent!(tableViewData[self.SearchRecordTable.selectedRow])
        }
    }
    
    override func viewWillAppear() {
        recordRequests.GETRequest(recordGetRequestBody: RecordGetRequestBody(Keyword: SearchText)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let jsonDecoder = JSONDecoder()
            
            if let recordItems = try? jsonDecoder.decode(RecordGetResponseBody.self, from: data) {
                self.tableViewData =  recordItems
                print("success!")
                print(recordItems.count)
                DispatchQueue.main.async {
                    if self.tableViewData.count == 0 {
                        let emptyRecord = RecordItem()
                        let emptyContent = Content(Form: "TEXT", Data: "No Result")
                        emptyRecord.Front.append(emptyContent)
                        self.tableViewData.append(emptyRecord)
                    }
                    self.SearchRecordTable.reloadData()
                }
            }
        }
    }
    
    
    
    @IBAction func CheckDetail(_ sender: Any) {
        
        var a = RecordItem()
        let b = Content(Form: "TEXT", Data: "test")
        a.Front.append(b)
        print(CheckDetailFromParent!)
        CheckDetailFromParent!(a)
    }
}

extension DisplaySearchRecordViewController:NSTableViewDataSource,NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var result:NSTableCellView
        result  = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        let displayRecord = self.tableViewData[row]
        if tableColumn?.identifier.rawValue == "Front" {
            result.textField?.stringValue = displayRecord.Content(pageIndex: PageIndex.front)
        } else {
            result.textField?.stringValue = displayRecord.Content(pageIndex: PageIndex.back)
        }
        return result
    }
}
