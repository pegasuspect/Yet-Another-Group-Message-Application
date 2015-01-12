//
//  CreateGroupController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit

class CreateGroupController: UIViewController {
    
    var data = Group()
    
    @IBOutlet weak var groupTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if groupTitleTextField.text.isEmpty {
            Data.showAlert("To Proceed", "You have to write the group title.")
            return false
        }
        
        data.title = groupTitleTextField.text
        
        Data.Groups.append(data)
        Data.Groups = Data.Groups
        Data.To = data
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
