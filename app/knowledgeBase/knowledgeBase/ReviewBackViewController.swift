//
//  ReviewBackViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/13.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewBackViewController: NSViewController {
    var delegate: ReviewBackOperationDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet weak var RecordContent: NSTextField!
    @IBAction func Omit(_ sender: NSButton) {
        self.delegate?.Omit(sender: sender)
    }
    
    @IBAction func Forget(_ sender: NSButton) {
        self.delegate?.Forget(sender: sender)
    }
    
    @IBAction func Remember(_ sender: NSButton) {
        self.delegate?.Remember(sender: sender)
    }
}
