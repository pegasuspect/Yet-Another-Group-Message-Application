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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        }
                    }
                }
                else if error != nil {
                    let alert = UIAlertView(title: "Error", message: error.localizedDescription,
                        delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //segue.destinationViewController =
    }
    
}
