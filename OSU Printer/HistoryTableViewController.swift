//
//  HistoryTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    // help to manage the PrintingHistory table in local database
    var myDBHelper = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // data shown in the tableView
    var data = [PrintingHistory]()
    
    // help to format the NSDate object
    var myDateFormatter = NSDateFormatter()
    
    // help to figure out if the printed file still exists
    var myFileHelper = FileSystemHelper()
    
    // number of sections, maybe I will support files in other format later and change this.
    let numberOfSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: .ValueChanged)
        
        myDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // load data from database
    func loadData() {
        if let loaded = myDBHelper.queryAllPrintingHistories() {
            data = loaded as! [PrintingHistory]
            self.tableView.reloadData()
        }
    }
    
    func reloadData(sender: AnyObject) {
        loadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrintingHistoryIdentifier", forIndexPath: indexPath) as! HistoryTableViewCell
        
        // Configure the cell...
        cell.filenameLabel?.text = data[indexPath.row].filename
        cell.descriptionLabel?.text = "Printed at \(myDateFormatter.stringFromDate(data[indexPath.row].printedAt))"
        cell.iconView?.image = UIImage(named: data[indexPath.row].fileType.rawValue)
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            myDBHelper.deleteAnPrintingHistory(data[indexPath.row])
            data.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tempIdentifier = segue.identifier {
            switch tempIdentifier {
            case "HistoryPreviewIdentifier":
                let destinationViewController = segue.destinationViewController as! PreviewController
                if let selectedIndex = tableView.indexPathForCell(sender as! HistoryTableViewCell)?.row {
                    destinationViewController.myFile = myFileHelper.transferFromPrintingHistoryToDocumentFile(data[selectedIndex])
                }
            default:
                break
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier != nil && identifier! == "HistoryPreviewIdentifier" {
            if let selectedIndex = tableView.indexPathForCell(sender as! HistoryTableViewCell)?.row {
                if !myFileHelper.fileExistsInRootFolder(data[selectedIndex].filename) {
                    showFileNotExistsAlert(selectedIndex)
                    return false
                }
            }
        }
        return true
    }
    
    func showFileNotExistsAlert(selectedIndex: Int) {
        let errorAlert = UIAlertController(
            title: "Sorry, the file doesn't exist, do you want to delete the record?",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        errorAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:
            {
                (alertAction: UIAlertAction!) -> Void in
                self.myDBHelper.deleteAnPrintingHistory(self.data[selectedIndex])
                self.data.removeAtIndex(selectedIndex)
                self.tableView.deleteRowsAtIndexPaths([selectedIndex], withRowAnimation: .Fade)
        }))
        
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(errorAlert, animated: true, completion: nil)

    }
    
}
