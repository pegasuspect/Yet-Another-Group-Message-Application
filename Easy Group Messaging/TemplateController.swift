//
//  TemplateController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit

class TemplateController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryName: String!
    
    var getListUrl = ""
    var data = [MessageTemplate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getListUrl = Category.baseUrl + "GetMessages.ashx"
        getListUrl += "?ContentLangCode=en-US"
        getListUrl += "&Category=" + categoryName
        
        fetch()
    }
    
    func fetch(){
        self.data = []
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            NSLog("Downloading started! For: " + self.getListUrl)
            var query = self.getListUrl
            query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let nsurl = NSURL(string: query)
            let noJsonData = NSData(contentsOfURL: nsurl!)
            let nsdata = NSData(contentsOfURL: nsurl!)
            let json = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.AllowFragments, error: nil) as 	[String: AnyObject]
            
            if let Data: AnyObject = json["Data"] {
                let dataValue = Data as [[String: AnyObject]]
                dispatch_async(dispatch_get_main_queue(), {
                    for category in dataValue {
                        var item = MessageTemplate()
                        item.date = category["Date"] as String
                        item.likeCount = category["LikeCount"] as Int
                        item.text = self.decodeString(category["Text"] as String)
                        
                        self.data.append(item)
                    }
                    
                    NSLog("Downloading finished!")
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TemplateTextCell") as UITableViewCell
        let template = data[indexPath.item]
        
        let txtLabel = cell.viewWithTag(1) as UILabel
        let dateLabel = cell.viewWithTag(2) as UILabel
        let likeBtn = cell.viewWithTag(3) as UISwitch
        
        txtLabel.text = template.text
        dateLabel.text = template.date
        
        likeBtn.on = template.liked
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decodeString(encodedString: String) -> String {
        let encodedData = encodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
        
        let decodedString = attributedString?.string // The Weeknd ‘King Of The Fall’
        return decodedString!
    }
}
