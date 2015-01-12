//
//  Data.swift
//  Easy Group Messaging
//
//  Created by studenty on 29/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import Foundation

struct Data {
    //Static variable definition
    private struct defaults {
        static let value: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    }
    internal static var Likes: NSMutableArray {
        get {
        if let data = defaults.value.objectForKey("likedIds") as? NSData {
        var object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSMutableArray
        return object
        }
        return NSMutableArray()
        }
        set {
            defaults.value.setObject(
                NSKeyedArchiver.archivedDataWithRootObject(newValue), forKey: "likedIds")
        }
    }
    
    internal static var Groups: [Group] {
        get {
            if let data = defaults.value.objectForKey("groups") as? NSData{
                var object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [[String: [[String: String]]]]
        
                var groups: [Group] = []
                for dict in object {
                    var group = Group()
                    group.fromDict(dict)
                    groups.append(group)
                }
                return groups
            }
            return []
        }
        set {
            var groupsDict: [[String: [[String: String]]]] = []
            for group in newValue{
                println(group.toString())
                groupsDict.append(group.toDict())
            }
            
            defaults.value.setObject(
                NSKeyedArchiver.archivedDataWithRootObject(groupsDict), forKey: "groups")
        }
    }
    
    private struct BaseURL { static let baseUrl: String = "http://messagetemplates.osmansekerlen.com/" }
    internal static var baseUrl: String {
        get { return BaseURL.baseUrl }
    }
    
    private struct contacts { static var value: [Member] = [] }
    internal static var Contacts: [Member] {
        get { return contacts.value }
        set { contacts.value = newValue }
    }
    
    private struct to { static var value: Group = Group(title: "eg. Close Friends") }
    internal static var To: Group {
        get { return to.value }
        set { to.value = newValue }
    }
    
    private struct msg { static var value = MessageTemplate(text: "eg. Some message text...") }
    internal static var Message: MessageTemplate {
        get { return msg.value }
        set { msg.value = newValue }
    }
    
    static func showAlert(title: String, _ msg: String){
        let alert = UIAlertView(title: title, message: msg,
            delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    static func getJSON(method: String, _ isDouble: Bool = true) -> [String: AnyObject]{
        var query = Data.baseUrl + method + "&rnd=" + rand().description
        query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let nsurl = NSURL(string: query)
        if isDouble{
            NSData(contentsOfURL: nsurl!)
        }
        let nsdata = NSData(contentsOfURL: nsurl!)
        let json = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.AllowFragments, error: nil) as [String: AnyObject]
        return json
    }
}