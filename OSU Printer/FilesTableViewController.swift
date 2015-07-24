//
//  FilesTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController {

    // help you manage files
    var myFileHelper = FileSystemHelper()
    
    // data to show
    var data = [DocumentFile]()
    
    // format NSDate object
    var myDateFormatter = NSDateFormatter()
    
    // will be changed later
    let numberOfSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        // To response to the "Open In" system call.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startFromBackground:", name:"applicationDidBecomeActive", object: nil)
        
        myDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: .ValueChanged)
    }
    
    // "Open in" will automatically add the file into /document/inbox, need to reload data.
    func startFromBackground(notification: NSNotification){
        if (self.isViewLoaded() && self.view.window != nil) {
            loadData()
        }
    }
    
    func loadData() {
        data = myFileHelper.getUserDocuments()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FilesTableCellIdentifier", forIndexPath: indexPath) as! FilesTableViewCell

        // Configure the cell...
        
        cell.filenameLabel?.text = data[indexPath.row].filename
        cell.fileDescriptionLabel?.text = "Modified at \(myDateFormatter.stringFromDate(data[indexPath.row].modifiedTime!))" + "\n" + "File size \(data[indexPath.row].filesizeInString)"
        cell.iconView?.image = UIImage(named: data[indexPath.row].fileType.rawValue)
        
        return cell
    }
    
    func reloadData(sender: AnyObject) {
        loadData()
        self.refreshControl?.endRefreshing()
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            myFileHelper.removeDocumentWithFilename(data[indexPath.row].filename)
            data.removeAtIndex(indexPath.row)
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
                    destinationViewController.toPrintFilename = data[selectedIndex].filename
                }
            default:
                break
            }
        }
    }

}
