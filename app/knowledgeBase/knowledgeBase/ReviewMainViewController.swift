//
//  ReviewMainViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/13.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewMainViewController: NSViewController, ReviewFrontOperationDelegate, ReviewBackOperationDelegate {
    
    
    // ####View
    // initialization
    private var selectedPageIndex: PageIndex = PageIndex.front
    private let reviewRequests: ReviewRequest = ReviewRequest()
    private let defaultSession = URLSession.shared
    var currentDate = Int(TrimToLocalDay(fromDate: Date()))
    private var Records = DisplayRecord()
    @IBOutlet weak var ReviewModeText: NSTextField!
    @IBOutlet weak var contentView: NSView!
        // ####Main View
        @IBAction func Refresh(_ sender: Any) {
            refreshData()
        }
    
        @IBAction func ChangeReviewMode(_ sender: NSButton) {
            self.Records.ToggleMode()
            refreshDisplay()
        }
    
    
        func setupViewController() {
            self.selectedPageIndex = PageIndex.front
            refreshViewController()
        }
    
        // ####Children View
    
        private lazy var reviewFrontViewController: ReviewFrontViewController = {
            var storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
            // Instantiate View Controller
            var viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ReviewFrontViewController")) as! ReviewFrontViewController
            
            // Add View Controller as Child View Controller
            self.addChildViewController(viewController)
//            self.add(asChildViewController: viewController)
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
    
            // #####Children view operations
    
            func Remember(sender: NSButton) {
                // change the data(remember and review date) of this record
                // if mode is unreviewed, move it to review array, remove it from unreivewed array
                if let currentRecord = self.Records.CurrentRecord {
//                    print(currentRecord.ReviewTimes)
                    if self.Records.mode == DisplayModeStatus.UnReviewedRecord && currentRecord.ReviewTimes! <= 1 {
                        if self.currentDate != currentRecord.RememberDate {
                            let requestBody = ReviewPutRequestBody(
                                RecordID: currentRecord.RecordID,
                                RememberDate: self.currentDate,
                                ReviewDate: self.currentDate + 2 * (currentRecord.ReviewDate - currentRecord.RememberDate),
                                CurrentReviewStatus: 1)
                            UpdateRecordRequestServer(requestBody: requestBody)
                            UpdateLocalRecord(requestBody: requestBody)
                        } else {
                            let requestBody = ReviewPutRequestBody(
                                RecordID: currentRecord.RecordID,
                                RememberDate: currentRecord.RememberDate,
                                ReviewDate: currentRecord.ReviewDate,
                                CurrentReviewStatus: 1)
                            UpdateRecordRequestServer(requestBody: requestBody)
                            UpdateLocalRecord(requestBody: requestBody)
                        }
                        self.Records.RemoveCurrentReviewedItem()
                    } else {
                        self.Records.ReoloadCurrentReviewedItem()
                    }
                    turnToFrontViewController()
                }
                
            }
    
            func Forget(sender: NSButton) {
                
                // if mode is reviewed, move it to unreviewed array, remve it from reviewed array
                if let currentRecord = self.Records.CurrentRecord {
                    let requestBody = ReviewPutRequestBody(
                        RecordID: currentRecord.RecordID,
                        RememberDate: self.currentDate,
                        ReviewDate: Int(Calendar.current.date(byAdding: .day, value: 1, to: Date(timeIntervalSince1970:TimeInterval(self.currentDate)))!.timeIntervalSince1970),
                        CurrentReviewStatus: 0)
                    self.Records.CurrentRecord!.ReviewTimes = 3
                    UpdateRecordRequestServer(requestBody: requestBody)
                    UpdateLocalRecord(requestBody: requestBody)
                    
                    
                    if self.selectedPageIndex == PageIndex.front {
                        turnToBackViewController()
                    } else {
                        if self.Records.mode == DisplayModeStatus.ReviewedRecord {
                            self.Records.RemoveCurrentReviewedItem()
                        } else {
                            self.Records.ReoloadCurrentReviewedItem()
                        }
                        turnToFrontViewController()
                    }
                }
            }
    
            func CheckResult(sender: NSButton) {
                turnToBackViewController()
            }
    
    @IBOutlet weak var ModificationButton: NSButton!
    
    @IBAction func ModifyRecord(_ sender: NSButton) {
        if let tabBarController = self.parent as? NSTabViewController {
            let recordViewController = tabBarController.childViewControllers[0] as! AdditionViewController
            recordViewController.CurrentRecord = self.Records.CurrentRecord
            recordViewController.mode = "PUT"
            recordViewController.BackTab = 1
            tabBarController.selectedTabViewItemIndex = 0
        }
    }
    
    func Omit(sender: NSButton) {
        self.Records.ReoloadCurrentReviewedItem()
        turnToFrontViewController()
    }
    

    
    override func viewWillAppear() {
        self.refreshDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        refreshData()
    }
    
    func setFrontButtonsHiddenStatus(status: Bool) {
        self.reviewFrontViewController.RememberButton.isHidden = status
        self.reviewFrontViewController.ForgetButton.isHidden = status
        self.reviewFrontViewController.CheckResultButton.isHidden = status
        
    }
    
    func refreshDisplay() {
        // mode text refreshment
        if self.Records.mode == DisplayModeStatus.ReviewedRecord {
            self.ReviewModeText.stringValue = "模式: 复习已掌握"
        } else {
            self.ReviewModeText.stringValue = "模式: 复习未掌握"
        }
        
        // content showed refreshment
        if let currentRecord = self.Records.CurrentRecord {
            setFrontButtonsHiddenStatus(status: false)
            self.ModificationButton.isHidden = false
            self.reviewFrontViewController.RecordFrontContent.stringValue = currentRecord.Content(pageIndex: PageIndex.front)
            self.reviewBackViewController.RecordContent.stringValue = currentRecord.Content(pageIndex: PageIndex.front) + "\n" + currentRecord.Content(pageIndex: PageIndex.back)
        } else {
            self.ModificationButton.isHidden = true
            setFrontButtonsHiddenStatus(status: true)
            self.reviewFrontViewController.RecordFrontContent.stringValue = "已完成"
        }
        
        // review status refreshment
        self.reviewFrontViewController.ReviewedNumberDisplayText.stringValue = "已掌握:" + String(describing: self.Records.ReviewedRecordCount)
        self.reviewFrontViewController.UnReviewedNumberDisplayText.stringValue = "未掌握:" + String(describing: self.Records.UnReviewedRecordCount)
        self.reviewFrontViewController.RemainDisplayText.stringValue = "剩余:" + String(describing: self.Records.ReviewOrderRemain)
        
        // button refresh
    }
    
    
    func refreshData() {
        turnToFrontViewController()
        self.reviewFrontViewController.RecordFrontContent.stringValue = "准备中"
        let ReviewGetRequestData = ReviewGetRequestBody(ReviewDate: Int(Date().timeIntervalSince1970))
        let jsonEncoder = JSONEncoder()
        let ReviewGetRequestJSON = try? jsonEncoder.encode(ReviewGetRequestData)
        print(String(data: ReviewGetRequestJSON!, encoding: String.Encoding.utf8)!)
        
        self.reviewRequests.GETRequest(ReviewGetRequestData: ReviewGetRequestData)
        { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let jsonDecoder = JSONDecoder()

            if let recordItems = try? jsonDecoder.decode(ReviewGetResponseBody.self, from: data) {
                self.Records = DisplayRecord(rs: recordItems)
                DispatchQueue.main.async {
                    print("In showing display after receiving data")
                    self.currentDate = Int(TrimToLocalDay(fromDate: Date()))
                    self.refreshDisplay()
                }
            }
        }
    }
    
    func UpdateLocalRecord(requestBody: ReviewPutRequestBody) {
        if let currentRecord = self.Records.RecordItems[requestBody.RecordID] {
           currentRecord.ReviewDate = requestBody.ReviewDate
           currentRecord.RememberDate = requestBody.RememberDate
           currentRecord.CurrentReviewStatus = requestBody.CurrentReviewStatus
           self.Records.RecordItems[requestBody.RecordID] = currentRecord
        }
    }
    
    private func UpdateRecordRequestServer(requestBody: ReviewPutRequestBody) {
        
        reviewRequests.PUTRequest(requestBody: requestBody)
        { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8)!)
        }
    }

    
    private func remove(asChildViewController viewController: NSViewController) {
        // Notify Child View Controller
        self.view.willRemoveSubview(contentView)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func add(asChildViewController viewController: NSViewController) {
        // Add Child View Controller
        addChildViewController(viewController)

        // Add Child View as Subview
        contentView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = contentView.bounds
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
    
    func turnToBackViewController() {
        if self.selectedPageIndex == PageIndex.front {
            remove(asChildViewController: reviewFrontViewController)
            add(asChildViewController: reviewBackViewController)
            self.selectedPageIndex = PageIndex.back
        }
        refreshDisplay()
    }
    
    func toggleViewController() {
        selectedPageIndex.toggle()
        refreshViewController()
    }
    

}
