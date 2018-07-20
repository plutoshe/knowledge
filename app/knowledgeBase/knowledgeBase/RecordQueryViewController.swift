//
//  RecordQueryViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/6/19.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class RecordQueryViewController: NSViewController {
    
    @IBOutlet weak var DisplayView: NSView!
    @IBOutlet weak var SearchKeyword: NSTextField!
    @IBOutlet weak var BackButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackButton.title = "First"
    }
    
    @IBAction func Search(_ sender: NSButton) {
        for child in self.childViewControllers {
            child.viewWillDisappear()
            self.DisplayView.willRemoveSubview(child.view)
            child.view.removeFromSuperviewWithoutNeedingDisplay()
            child.removeFromParentViewController()
        }
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
        let viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DisplaySearchRecordViewController")) as! DisplaySearchRecordViewController
        viewController.CheckDetailFromParent = DisplayDetailRecord
        viewController.SearchText = SearchKeyword.stringValue
        self.addChildViewController(viewController)
        viewController.view.frame = self.DisplayView.bounds
        self.DisplayView.addSubview(viewController.view)
    }
    

    @IBAction func BackFromChild(_ sender: Any) {
        if BackButton.title == "Back " {
            if let lastChildren = self.childViewControllers.last {
                lastChildren.viewWillDisappear()
                self.DisplayView.willRemoveSubview(lastChildren.view)
                lastChildren.view.removeFromSuperviewWithoutNeedingDisplay()
                lastChildren.removeFromParentViewController()
                self.childViewControllers.last!.view.isHidden = false
                if self.DisplayView.subviews.count == 1 {
                    BackButton.title = "First"
                }
            }
        }
    }
    
    func DisplayDetailRecord(record: RecordItem) {
        self.BackButton.title = "Back "
        self.DisplayView.subviews.last!.isHidden = true
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
        let viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DisplayRecordViewController")) as! DisplayRecordViewController
        viewController.DisplayRecord = record
        self.addChildViewController(viewController)
        self.DisplayView.addSubview(viewController.view)
        viewController.view.frame = self.DisplayView.bounds
        
//        self.DisplayView.addSubview(viewController.view, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
    }
    
    @IBAction func DisplayRecord(_ sender: Any) {
        
        
    }
}
