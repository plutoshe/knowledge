//
//  AdditionViewController.swift
//  knowledgeBase
//
//  Created by PlutoShe on 2018/2/23.
//  Copyright © 2018 PlutoShe. All rights reserved.
//

import Cocoa

//let AdditionPostURL = URL("http://127.0.0.1:16759")

class AdditionViewController: NSViewController {

    @IBOutlet weak var FrontContent: NSTextField!
    @IBOutlet weak var BackContent: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func submitRecord(_ sender: Any) {
        let myAlert = NSAlert()
        print(FrontContent.stringValue)
        let AdditionPostData = AdditionBody(
            FrontContent: [Content(Form:"TEXT", Data:FrontContent.stringValue)],
            BackContent: [Content(Form:"TEXT", Data:BackContent.stringValue)]
        )
        let jsonEncoder = JSONEncoder()
        let AdditionPostJSON = try? jsonEncoder.encode(AdditionPostData)
        myAlert.messageText = String(data: try! jsonEncoder.encode(AdditionPostData), encoding: String.Encoding.utf8)!

        
        let url = URL(string: "http://127.0.0.1:16759/record")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = AdditionPostJSON
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        
        myAlert.runModal()
    }
}
