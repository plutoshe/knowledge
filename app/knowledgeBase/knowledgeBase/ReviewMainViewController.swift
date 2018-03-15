//
//  ReviewMainViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/13.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewMainViewController: NSViewController, ReviewFrontOperationDelegate, ReviewBackOperationDelegate {
    
    // initialization
    private var selectedPageIndex: PageIndex = PageIndex.front
    
    private let defaultSession = URLSession.shared
    var currentDate: Int = Int(Date().timeIntervalSince1970)
    private var Records = DisplayRecord()
    private var DataTask: URLSessionDataTask? = nil
    @IBOutlet weak var ReviewModeText: NSTextField!
    @IBOutlet weak var contentView: NSView!
    
    private lazy var reviewFrontViewController: ReviewFrontViewController = {
        var storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
        // Instantiate View Controller
        var viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ReviewFrontViewController")) as! ReviewFrontViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        viewController.delegate = self
        //        self.view.addSubview(viewController.view)
        
        return viewController
    }()
    
    private lazy var reviewBackViewController: ReviewBackViewController = {
        var storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
        // Instantiate View Controller
        var viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ReviewBackViewController")) as! ReviewBackViewController
        
        // Add View Controller as Child View Controller
        self.addChildViewController(viewController)
        viewController.delegate = self
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        refreshData()
    }
    
    // Operations in Children
    
    func SwitchStateOfRecord() {
        self.Records.RecordItems[self.Records.Status.reversedMode()]!.append(self.Records.CurrentRecord)
        self.Records.RecordItems[self.Records.Status.mode]!.remove(at: self.Records.Status.displayItem)
    }
    
    func Remember(sender: NSButton) {
        // change the data(remember and review date) of this record
        
        if self.Records.CurrentRecord.RememberDate != currentDate {
            var reviewRequestBody = ReviewPutRequestBody(
                RecordID: self.Records.CurrentRecord.RecordID,
                RememberDate: self.currentDate,
                ReviewDate: self.currentDate + 2 * (self.Records.CurrentRecord.ReviewDate - self.Records.CurrentRecord.RememberDate))
        }
        
        // if mode is unreviewed, move it to review array, remove it from unreivewed array
        if self.Records.Status.mode == DisplayModeStatus.UnReviewedRecord {
            SwitchStateOfRecord()
        }
        turnToFrontViewController()
        reselectDisplayItem()
        refreshDisplay()
    }
    
    func Forget(sender: NSButton) {
        // change the data(remember and review date) of this record
        var reviewPutRequestBody = ReviewPutRequestBody(
            RecordID: self.Records.CurrentRecord.RecordID,
            RememberDate: self.currentDate,
            ReviewDate: Int(Calendar.current.date(byAdding: .day, value: 1, to: Date(timeIntervalSince1970:TimeInterval(self.currentDate)))!.timeIntervalSince1970))
        
        // if mode is reviewed, move it to unreviewed array, remve it from reviewed array
        if self.Records.Status.mode == DisplayModeStatus.ReviewedRecord {
            SwitchStateOfRecord()
        }
        turnToFrontViewController()
        reselectDisplayItem()
        refreshDisplay()
    }
    
    func CheckResult(sender: NSButton) {
        toggleViewController()
    }
    
    func Omit(sender: NSButton) {
        reselectDisplayItem()
        toggleViewController()
    }

    
    // Opeartions in self
    
    @IBAction func ChangeReviewMode(_ sender: NSButton) {
        self.Records.Status.ToggleMode()
        reselectDisplayItem()
        refreshDisplay()
    }
    
    
    func setupViewController() {
        self.selectedPageIndex = PageIndex.front
        refreshViewController()
    }
    
    func toggleMode() {
        self.Records.Status.ToggleMode()
    }
    
    func reselectDisplayItem() {
        if let size = self.Records.RecordItems[self.Records.Status.mode]?.count, size > 0{
            self.Records.Status.displayItem = Int(arc4random_uniform(UInt32(size)))
        } else {
            self.Records.Status.displayItem = -1
        }
        
    }
    
    func refreshDisplay() {
        // Front
        if self.Records.Status.mode == DisplayModeStatus.ReviewedRecord {
            self.ReviewModeText.stringValue = "复习模式:\n复习已掌握"
        } else {
            self.ReviewModeText.stringValue = "复习模式:\n复习未掌握"
        }
        
        if self.Records.Status.displayItem == -1 {
            self.reviewFrontViewController.RecordFrontContent.stringValue = "已完成"
        } else {
            self.reviewFrontViewController.RecordFrontContent.stringValue = self.Records.CurrentRecord.Content(pageIndex: PageIndex.front)
            self.reviewBackViewController.RecordContent.stringValue = self.Records.CurrentRecord.Content(pageIndex: PageIndex.back)
            
        }
        self.reviewFrontViewController.ReviewedNumberDisplayText.stringValue = "已掌握:" + String(describing: self.Records.RecordItems[DisplayModeStatus.ReviewedRecord]!.count)
        self.reviewFrontViewController.UnReviewedNumberDisplayText.stringValue = "未掌握:" + String(describing: self.Records.RecordItems[DisplayModeStatus.UnReviewedRecord]!.count)
        
    }
    
    
    func refreshData() {
        
        let ReviewGetRequestData = ReviewGetRequestBody(ReviewDate: Int(Date().timeIntervalSince1970))
        if let DataTask = DataTask {
            DataTask.cancel()
        }
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
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let jsonDecoder = JSONDecoder()
//            print("!!!!")
            
            //            do {
            if let recordItems = try? jsonDecoder.decode(ReviewGetResponseBody.self, from: data) {
                self.Records = DisplayRecord(rs: recordItems)
                self.reselectDisplayItem()
                DispatchQueue.main.async {
                    self.refreshDisplay()
                }
            }
        }
        DataTask!.resume()
    }

    
    private func remove(asChildViewController viewController: NSViewController) {
        // Notify Child View Controller
        self.view.willRemoveSubview(viewController.view)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func add(asChildViewController viewController: NSViewController) {
        // Add Child View Controller
        addChildViewController(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
    }
    
    func refreshViewController() {
        if self.selectedPageIndex == PageIndex.back {
            remove(asChildViewController: reviewFrontViewController)
            add(asChildViewController: reviewBackViewController)
        } else {
            remove(asChildViewController: reviewBackViewController)
            add(asChildViewController: reviewFrontViewController)
        }
        refreshDisplay()
    }
    
    func turnToFrontViewController() {
        if self.selectedPageIndex == PageIndex.back {
            remove(asChildViewController: reviewBackViewController)
            add(asChildViewController: reviewFrontViewController)
            self.selectedPageIndex = PageIndex.front
        }
        refreshDisplay()
    }
    
    func toggleViewController() {
        selectedPageIndex.toggle()
        refreshViewController()
    }
    
    @IBAction func TollPage(_ sender: NSButton) {
        toggleViewController()
    }
    @IBAction func Refresh(_ sender: Any) {
    }
}
