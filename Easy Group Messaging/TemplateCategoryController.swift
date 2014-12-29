//
//  ChooseCategoryController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit

class TemplateCategoryController: UITableViewController {
    
    var getListUrl = ""
    var data = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getListUrl = Category.baseUrl + "GetMessageCategories.ashx"
        getListUrl += "?ContentLangCode=en-US"
        fetch()
    }
    
    func fetch(){
        self.data = []
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            NSLog("Downloading started! For: " + self.getListUrl)
            let query = self.getListUrl + "&rnd=" + rand().description
            let nsurl = NSURL(string: query)
            let noJsonData = NSData(contentsOfURL: nsurl!)
            let nsdata = NSData(contentsOfURL: nsurl!)
            let json = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.AllowFragments, error: nil) as 	[String: AnyObject]
            
            if let Data: AnyObject = json["Data"] {
                let dataValue = Data as [String]
                for category in dataValue {
                    var item = Category()
                    item.title = category
                    
                    self.data.append(item)
                }
                dispatch_async(dispatch_get_main_queue(), {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryName") as UITableViewCell
        let category = data[indexPath.item]
        cell.textLabel!.text = category.title
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
            let memberVC = segue.destinationViewController as TemplateController
            memberVC.categoryName = data[indexPath!.item].title
    }
    
}
