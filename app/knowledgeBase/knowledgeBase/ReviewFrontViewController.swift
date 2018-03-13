//
//  ReviewViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/8.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewFrontViewController: NSViewController {
    let defaultSession = URLSession.shared
    var delegate: ReviewFrontOperationDelegate?
    @IBOutlet weak var ReviewedNumberDisplayText: NSTextField!
    @IBOutlet weak var UnReviewedNumberDisplayText: NSTextField!
    @IBOutlet weak var RecordFrontContent: NSTextField!

    var Records: DisplayRecord? = nil
    var Status: DisplayRecordStatus = DisplayRecordStatus()
    var DataTask: URLSessionDataTask? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        refresh()
        // Do view setup here.
    }

    func reselectDisplayItem() {

        if let number = self.Records?.RecordItems[self.Status.mode]?.count {
                self.Status.displayItem = Int(arc4random_uniform(UInt32(number)))
            } else {
                self.Status.displayItem = -1
            }

    }
    
    func refreshDisplayText() {
        self.ReviewedNumberDisplayText.stringValue = "已掌握:" + String(describing: self.Records!.RecordItems[DisplayModeStatus.ReviewedRecord]!.count)
        self.UnReviewedNumberDisplayText.stringValue = "未掌握:" + String(describing: self.Records!.RecordItems[DisplayModeStatus.UnReviewedRecord]!.count)
        if self.Status.displayItem >= 0 {
            self.RecordFrontContent.stringValue = (self.Records?.GetCurrentStatusRecord(display: self.Status).Front[0].Data)!
        } else {
            self.RecordFrontContent.stringValue = ""
        }
    }

    func refresh() {
        if let DataTask = DataTask {
            DataTask.cancel()
        }
        let ReviewGetRequestData = ReviewGetRequestBody(ReviewDate: Int(Date().timeIntervalSince1970))
        let jsonEncoder = JSONEncoder()
        let ReviewGetRequestJSON = try? jsonEncoder.encode(ReviewGetRequestData)
        print(String(data: ReviewGetRequestJSON!, encoding: String.Encoding.utf8)!)
        let urlComponents = NSURLComponents(string: ReviewURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "HasTag", value: String(ReviewGetRequestData.HasTag)),
            URLQueryItem(name: "Tags", value: ReviewGetRequestData.Tags.joined(separator: ",")),
            URLQueryItem(name: "ReviewDate", value: String(ReviewGetRequestData.ReviewDate)),
            URLQueryItem(name: "RememberDate", value: String(ReviewGetRequestData.RememberDate)),
        ]
        let ReviewGetURL = urlComponents.url
        var request : URLRequest = URLRequest(url: ReviewGetURL!)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = ReviewGetRequestJSON

        DataTask = defaultSession.dataTask(with: request)
        { (data, response, error) in
            defer { self.DataTask = nil }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8)!)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let jsonDecoder = JSONDecoder()
            print("!!!!")
            
            //            do {
            if let recordItems = try? jsonDecoder.decode(ReviewGetResponseBody.self, from: data) {
                self.Records = DisplayRecord(rs: recordItems)
                    self.reselectDisplayItem()
                    DispatchQueue.main.async {
                        self.refreshDisplayText()
                    }
            }
        }
        DataTask!.resume()
    }

    @IBAction func CheckResult(_ sender: Any) {
        //prepare(for: "ReviewToBack", sender: _)
    }

    @IBAction func Remember(_ sender: NSButton) {
        self.delegate!.Remember(sender: sender)
    }
    
    @IBAction func Forget(_ sender: Any) {
        // review->today+1day
        // remember->today
        //prepare(for: "ReviewToBack", sender: _)
    }

    @IBAction func Refresh(_ sender: Any) {
        refresh()
    }
    
}
