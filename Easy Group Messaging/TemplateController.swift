//
//  TemplateController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit

class TemplateController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var offImg = UIImage(named: "logo132x36.png")
    var onImg = UIImage(named: "logo232x36.png")
    var categoryName: String!
    
    var getListUrl = ""
    var data = [MessageTemplate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getListUrl = "GetMessages.ashx"
        getListUrl += "?ContentLangCode=en-US"
        getListUrl += "&Category=" + categoryName
        
        fetch()
    }
    
    func fetch(){
        self.data = []
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            NSLog("Downloading started! For: " + self.getListUrl)
            var query = self.getListUrl
            
            let json = Data.getJSON(self.getListUrl)
            
            if let Data: AnyObject = json["Data"] {
                let dataValue = Data as [[String: AnyObject]]
                
                for category in dataValue {
                    var item = MessageTemplate()
                    item.date = category["Date"] as String
                    item.likeCount = category["LikeCount"] as Int
                    item.text = category["Text"] as String
                    
                    self.data.append(item)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    NSLog("Downloading finished!")
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    @IBAction func touchUpInside(sender: AnyObject) {
        var btn = sender as UIButton
        btn.selected = !btn.selected
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TemplateTextCell") as UITableViewCell
        let template = data[indexPath.item]
        
        let txtLabel = cell.viewWithTag(1) as UILabel
        let dateLabel = cell.viewWithTag(2) as UILabel
        let likeCountLabel = cell.viewWithTag(4) as UILabel

        let likeBtn = cell.viewWithTag(3) as UIButton
        
        txtLabel.text = template.text
        dateLabel.text = template.date
        likeCountLabel.text = template.likeCount.description
        
        likeBtn.setBackgroundImage(onImg, forState: UIControlState.Selected)
        likeBtn.setBackgroundImage(offImg, forState: UIControlState.Normal)
        
        likeBtn.selected = template.liked
        
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
