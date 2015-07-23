//
//  HistoryTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var myDBHelper: DatabaseHelper!
    
    var data = [PrintingHistory]()
    
    var myDateFormatter = NSDateFormatter()
    
    var myFileHelper = FileSystemHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        
        if myDBHelper == nil {
            myDBHelper = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
        }
        
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: .ValueChanged)
        
        myDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
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
            case "HistoryReprintIdentifier":
                let destinationViewController = segue.destinationViewController as! PrintingSettingsTableViewController
                if let selectedIndex = tableView.indexPathForCell(sender as! HistoryTableViewCell)?.row {
                    destinationViewController.toPrintFoldername = myFileHelper.DocumentsRootPath
                    destinationViewController.toPrintFilename = data[selectedIndex].filename
                }
            default:
                break
            }
        }
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier != nil && identifier! == "HistoryReprintIdentifier" {
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
            title: "Alert",
            message: "Sorry, the file doesn't exist, do you want to delete the record?",
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
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
