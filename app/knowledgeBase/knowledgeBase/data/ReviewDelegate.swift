//
//  ReviewFrontDelegate.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/13.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

protocol ReviewFrontOperationDelegate {
    func Remember(sender: NSButton)
    
    func Forget(sender: NSButton)
    
    func CheckResult(sender: NSButton)
}

protocol ReviewBackOperationDelegate {
    func Remember(sender: NSButton)
    
    func Forget(sender: NSButton)
    
    func Omit(sender: NSButton)
    
    //    func Remember()
    //    func CheckResult()    
}
