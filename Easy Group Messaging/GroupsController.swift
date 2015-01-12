//
//  GroupsController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit
import AddressBook

class GroupsController: UITableViewController {
    
    var addressBook = APAddressBook()
    var data = Data.Groups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Data.Contacts.count == 0 {
            loadContactsToRam()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        data = Data.Groups
        self.tableView.reloadData()
        
    }
    
    func loadContactsToRam(){
        self.addressBook.fieldsMask = APContactField.Default | APContactField.Thumbnail
        
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
            NSSortDescriptor(key: "lastName", ascending: true)]
        self.addressBook.filterBlock = {(contact: APContact!) -> Bool in
            return contact.phones.count > 0
        }
        self.addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if contacts != nil {
                    for contact in contacts{
                        if let contactsValue = contact as? APContact {
                            var name = ""
                            if contactsValue.firstName != nil {
                                name += contactsValue.firstName
                            }
                            if contactsValue.middleName != nil {
                                name += " " + contactsValue.middleName
                            }
                            if contactsValue.lastName != nil {
                                name += " " + contactsValue.lastName
                            }
                            var phoneNo = contactsValue.phones![0].description
                            println(name + ", " + phoneNo)
                            
                            var member = Member()
                            member.name = name
                            member.phoneNumber = phoneNo
                            
                            Data.Contacts.append(member)
                        }
                    }
                }
                else if error != nil {
                    Data.showAlert("Error", error.localizedDescription)
                }
        })
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupsCell") as UITableViewCell
        let group = data[indexPath.item]
        cell.textLabel!.text = group.title
        cell.detailTextLabel?.text = ",".join(group.members.map { $0.name })
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupsCell") as UITableViewCell
        let group = data[indexPath.item]
        
        group.selected = true
        Data.To = group
    }	

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    @IBAction func unwindToGroupsSelectionPage(segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == "SelectContactsSegue"{
            
            if (APAddressBook.access() == APAddressBookAccess.Denied
                || APAddressBook.access() == APAddressBookAccess.Unknown)
            {
                let alert = UIAlertView(title: "To proceed", message: "You have to grant access to your phonebook.",
                    delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            return true
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectContactSegue" {
            let contactsVC = segue.destinationViewController as ContactsController
            contactsVC.currentGroup = Group()
            return
        }
    }
    
}
