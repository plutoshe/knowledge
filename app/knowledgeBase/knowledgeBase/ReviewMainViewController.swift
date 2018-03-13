//
//  ReviewMainViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/3/13.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

class ReviewMainViewController: NSViewController {


    
    @IBOutlet weak var contentView: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do view setup here.
    }
    
    func setupView() {
        self.selectedPageIndex = 0
        updateView()
    }
    
    private var selectedPageIndex: Int = 0
    private lazy var reviewFrontViewController: ReviewFrontViewController = {
        var storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
        // Instantiate View Controller
        var gg = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ReviewFrontViewController"))
        var viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ReviewFrontViewController")) as! ReviewFrontViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

//        self.view.addSubview(viewController.view)

        return viewController
    }()
    
    private lazy var reviewBackViewController: ReviewBackViewController = {
        var storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: Bundle.main)
        // Instantiate View Controller
        var viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ReviewBackViewController")) as! ReviewBackViewController
        
        
        // Add View Controller as Child View Controller
        self.addChildViewController(viewController)
//        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func remove(asChildViewController viewController: NSViewController) {
        // Notify Child View Controller
//        viewController.willMove(toParentViewController: nil)
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
//        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
//        viewController.didMove(toParentViewController: self)
    }
    
    func updateView() {
        if self.selectedPageIndex == 1 {
            remove(asChildViewController: reviewFrontViewController)
            add(asChildViewController: reviewBackViewController)
        } else {
            remove(asChildViewController: reviewBackViewController)
            add(asChildViewController: reviewFrontViewController)
        }
    }
    
    @IBAction func TollPage(_ sender: NSButton) {
        selectedPageIndex = 1 - selectedPageIndex
        updateView()
    }
}
