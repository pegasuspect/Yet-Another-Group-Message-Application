//
//  MessageTemplate.swift
//  Easy Group Messaging
//
//  Created by studenty on 24/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import Foundation

struct Category {
    var title: String = ""
    
    //Static variable definition
    private struct BaseURL { static let baseUrl: String = "http://messagetemplates.osmansekerlen.com/" }
    internal static var baseUrl: String {
        get { return BaseURL.baseUrl }
    }
    
    var templates: [MessageTemplate] = []
}