//
//  MessageTemplate.swift
//  Easy Group Messaging
//
//  Created by studenty on 24/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import Foundation

class Category {
    var title: String = ""
    var templates: [MessageTemplate] = []
}

class Group {
    var title: String = ""
    var members: [Member]
    
    var selected = false
    
    init(){
        self.members = []
    }
    
    init(title: String){
        self.title = title
        self.members = []
    }
    
    func fromDict(dict: [String: [[String: String]]]){
        for (key, members) in dict {
            self.title = key
            
            var membersVal: [Member] = []
            for member in members{
                var m = Member()
                m.fromDict(member)
                membersVal.append(m)
            }
            self.members = membersVal
        }
    }
    
    func toDict() -> [String: [[String: String]]] {
        var result = [String: [[String: String]]]()
        
        var membersDict: [[String: String]] = []
        for member in members {
            membersDict.append(member.toDict())
        }
        result[self.title] = membersDict
        
        return result
    }
    
    func toString() -> String {
        return "Group Title: \(title) Members: " + "\n".join( members.map({ $0.toString() }) )
    }
}

class Member {
    var name = ""
    var phoneNumber = ""
    var selected = false
    
    func toDict() -> [String: String] {
        var result = [String: String]()
        
        result["name"] = self.name
        result["phoneNumber"] = self.phoneNumber
        
        return result
    }
    
    func fromDict(dict: [String: String]) {
        self.name = dict["name"]!
        self.phoneNumber = dict["phoneNumber"]!
    }
    
    func toString() -> String {
        return "Name: \(name), Phone: \(phoneNumber)"
    }
}