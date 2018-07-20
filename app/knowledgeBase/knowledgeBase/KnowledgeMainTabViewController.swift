//
//  KnowledgeMainTabViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/7/20.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class KnowledgeMainTabViewController: NSTabViewController {

    @objc func moveToPreviousTab() {
        if self.selectedTabViewItemIndex == 0 {
            self.selectedTabViewItemIndex = self.tabViewItems.count - 1
        } else {
            self.selectedTabViewItemIndex -= 1
        }
    }
    
    @objc func moveToNextTab() {
        if self.selectedTabViewItemIndex == self.tabViewItems.count - 1 {
            self.selectedTabViewItemIndex = 0
        } else {
            self.selectedTabViewItemIndex += 1
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let menu = NSApp!.menu {
            menu.item(withTitle: "Window")!.submenu!.item(withTitle: "Show Previous Tab")!.action = #selector(moveToPreviousTab)
            menu.item(withTitle: "Window")!.submenu!.item(withTitle: "Show Next Tab")!.action = #selector(moveToNextTab)
            
        }
        // Do view setup here.
    }
    
    
}
