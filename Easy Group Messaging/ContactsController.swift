//
//  ChooseCategoryController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit

class ContactsController: UITableViewController {
    
    var data = Data.Contacts
    
    var currentGroup = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        for contact in data {
            contact.selected = false
        }
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectContactsCell") as UITableViewCell
        let member = data[indexPath.item]
        cell.textLabel!.text = member.name
        cell.detailTextLabel?.text = member.phoneNumber
        
        if (member.selected)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectContactsCell") as UITableViewCell
        let member = data[indexPath.item]
        
        member.selected = !member.selected
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        for contact in data {
            if contact.selected {
                var m = Member()
                m.name = contact.name
                m.phoneNumber = contact.phoneNumber
                currentGroup.members.append(m)
            }
        }
        
        if currentGroup.members.count == 0 {
            Data.showAlert("To Proceed", "You have to select at least 1 contact.")
            return false
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destionationPage = segue.destinationViewController as CreateGroupController
        destionationPage.data = currentGroup
    }
    
}
