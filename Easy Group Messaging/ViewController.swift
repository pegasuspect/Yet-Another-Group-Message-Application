//
//  ViewController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var reciepents: [String] = []
    var cost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        toLabel.text = Data.To.title
        messageLabel.text = Data.Message.text
        reciepents = Data.To.members.map({ return $0.phoneNumber })
        cost = reciepents.count * ((countElements(Data.Message.text) / 160) + 1)
        totalCostLabel.text = cost.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTapped(sender: AnyObject) {
        if cost == 0 {
            Data.showAlert("No Group Selected", "Select a group from top right to crete a message for them.")
            return
        }
        launchMessageComposeViewController()
    }
    
    @IBAction func unwindTo(segue: UIStoryboardSegue) {
        
    }
    
    // prepend this function with @IBAction if you want to call it from a Storyboard.
    func launchMessageComposeViewController() {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = self.reciepents
            messageVC.body = self.messageLabel?.text
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            Data.showAlert("Error", "User hasn't setup Messages.app")
        }
    }
    
    // this function will be called after the user presses the cancel button or sends the text
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var identifier = segue.identifier
        
        if(identifier=="groups"){
            let memberVC = segue.destinationViewController as GroupsController
            memberVC.data = Data.Groups
        }
        if(identifier=="templates"){
            let memberVC = segue.destinationViewController as TemplateCategoryController
        }
    }

}

