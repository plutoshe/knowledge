//
//  ReviewViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/8.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewFrontViewController: NSViewController {
    var delegate: ReviewFrontOperationDelegate?
    @IBOutlet weak var ReviewedNumberDisplayText: NSTextField!
    @IBOutlet weak var UnReviewedNumberDisplayText: NSTextField!
    @IBOutlet weak var RecordFrontContent: NSTextField!
    
    @IBOutlet weak var RememberButton: NSButton!
    @IBOutlet weak var ForgetButton: NSButton!
    @IBOutlet weak var CheckResultButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecordFrontContent.lineBreakMode = .byWordWrapping
//        RecordFrontContent.setContentCompressionResistancePriority(250, forOrientation: .Horizontal)
    }
    
    @IBAction func CheckResult(_ sender: NSButton) {
        self.delegate?.CheckResult(sender: sender)
    }

    @IBAction func Remember(_ sender: NSButton) {
        self.delegate?.Remember(sender: sender)
    }
    
    @IBAction func Forget(_ sender: NSButton) {
        self.delegate?.Forget(sender: sender)
    }


    
}
