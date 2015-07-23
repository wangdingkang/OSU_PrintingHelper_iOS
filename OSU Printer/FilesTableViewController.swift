//
//  FilesTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController {

    
    var myFileHelper = FileSystemHelper()
    
    var shownFiles = [DocumentFile]()
    
    var myDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startFromBackground:", name:"applicationDidBecomeActive", object: nil)
        
        
        myDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: .ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func startFromBackground(notification: NSNotification){
        if (self.isViewLoaded() && self.view.window != nil) {
            shownFiles = myFileHelper.getUserDocuments()
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        shownFiles = myFileHelper.getUserDocuments()
        print("Files count: \(shownFiles.count)\n")
        tableView.reloadData()
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
        return shownFiles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilesTableCellIdentifier", forIndexPath: indexPath) as! FilesTableViewCell

        // Configure the cell...

        cell.filenameLabel?.text = shownFiles[indexPath.row].filename
        cell.fileDescriptionLabel?.text = "Modified at \(myDateFormatter.stringFromDate(shownFiles[indexPath.row].modifiedTime!))" + "\n" + "File size \(shownFiles[indexPath.row].filesizeInString)"
        
        return cell
    }
    
    func reloadData(sender: AnyObject) {
        shownFiles = myFileHelper.getUserDocuments()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    @objc func startFromOtherApplication(notification: NSNotification){
        shownFiles = myFileHelper.getUserDocuments()
        tableView.reloadData()
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
            myFileHelper.removeDocumentWithFilename(shownFiles[indexPath.row].filename)
            shownFiles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tempIdentifier = segue.identifier {
            switch tempIdentifier {
            case "PrintFileIdentifier":
                let destinationViewController = segue.destinationViewController as! PrintingSettingsTableViewController
                if let selectedIndex = tableView.indexPathForCell(sender as! FilesTableViewCell)?.row {
                    destinationViewController.toPrintFoldername = myFileHelper.DocumentsRootPath
                    destinationViewController.toPrintFilename = shownFiles[selectedIndex].filename
                }
            default:
                break
            }
        }
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
