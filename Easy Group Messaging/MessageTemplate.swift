//
//  MessageTemplate.swift
//  Easy Group Messaging
//
//  Created by studenty on 24/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import Foundation

class MessageTemplate {
    var text: String = ""
    var likeCount: Int = 0
    var index: Int = 0
    var date: String = ""
    var id: String = ""
    var liked: Bool = false
    
    init(){}
    
    init(text: String){
        self.text = text
    }
    
    func like(callback: () -> ()){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            
            let json = Data.getJSON("LikeIt.ashx?id=" + self.id, false)
            
            if let Data: AnyObject = json["Data"] {
                if let dataValue = Data as? Bool{
                    if dataValue {
                        dispatch_async(dispatch_get_main_queue(), {
                            NSLog("liked " + self.id + "!")
                            self.liked = true
                            self.likeCount++
                            callback()
                        })
                    }
                }
            }
        })
    }
    
    func dislike(callback: () -> ()){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            let json = Data.getJSON("DislikeIt.ashx?id=" + self.id, false)
            
            if let Data: AnyObject = json["Data"] {
                if let dataValue = Data as? Bool{
                    if dataValue {
                        dispatch_async(dispatch_get_main_queue(), {
                            NSLog("disliked " + self.id + "!")
                            self.liked = false
                            self.likeCount--
                            callback()
                        })
                    }
                }
            }
        })
    }
    
}
