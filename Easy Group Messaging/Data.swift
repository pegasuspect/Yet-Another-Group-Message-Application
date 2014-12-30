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
    private struct likesDict {
        static let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    }
    internal static var LikesDict: NSDictionary {
        get {
            if let data = likesDict.defaults.objectForKey("likedIds") as? NSData{
                var object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary
                return object
            }
        return [String: Bool]()
        }
        set {
            likesDict.defaults.setObject(
                NSKeyedArchiver.archivedDataWithRootObject(newValue), forKey: "likedIds")
        }
    }
}