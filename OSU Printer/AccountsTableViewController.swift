//
//  AccountsTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit
import CoreData

class AccountsTableViewController: UITableViewController, SendDataBackProtocol{
    
    var data = [Account]()
    
    var tempUser: TempUser?
    
    var myAppBundleHelper = AppBundleHelper.sharedInstance
    
    var myDBHelper: DatabaseHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        // init my DBHelper
        if myDBHelper == nil {
            myDBHelper = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
        }
        
        tempUser = myAppBundleHelper.getTempUser()
        
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: .ValueChanged)
        
        // add long pressed gesture recognizer to detect the "change-account" action
        //var longPressedGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        //longPressedGesture.minimumPressDuration = 1.0
        //self.tableView.addGestureRecognizer(longPressedGesture)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("About to show viewWillApear \n")
        if let loadedData = myDBHelper?.queryAllAccounts() {
            //print("\(loadedData.count)\n")
            //print("Loading Data\n")
            data = loadedData as! [Account]
            tableView.reloadData()
        }
    }
    
    func reloadData(sender: AnyObject) {
        if let loadedData = myDBHelper?.queryAllAccounts() {
            //print("\(loadedData.count)\n")
            //print("Loading Data\n")
            data = loadedData as! [Account]
            tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func longPressed(recognizer: UILongPressGestureRecognizer) {
//        if recognizer.state == UIGestureRecognizerState.Began {
//            let p = recognizer.locationInView(self.tableView)
//            if let indexPath: NSIndexPath?  = self.tableView.indexPathForRowAtPoint(p) {
//                print("Long Pressed Start \(indexPath!.row) \n")
//                showUpdateTempUser(indexPath!.row)
//            }
//        } else if recognizer.state == UIGestureRecognizerState.Ended {
//            print("Long Pressed End \n")
//        }
//    }
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showUpdateTempUser(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = data[indexPath.row].username
        cell.detailTextLabel?.text = data[indexPath.row].department
        
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        
        if tempUser != nil {
            if data[indexPath.row].username == tempUser!.username && data[indexPath.row].department == tempUser!.department {
                cell.textLabel?.textColor = UIColor.redColor()
                cell.detailTextLabel?.textColor = UIColor.redColor()
            }
        }
        
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
            if tempUser != nil {
                if tempUser!.username == data[indexPath.row].username && tempUser!.department == data[indexPath.row].department {
                    myAppBundleHelper.removeTempUser()
                    tempUser = nil
                }
            }
            myDBHelper.deleteAnAccount(data[indexPath.row] as NSManagedObject)
            data.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // Override the supported editing actions
    //override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    //    var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
    //            self.showEditAlert(indexPath)
    //    })
    //
    //    var deleteAction = UITableViewRowAction(style: .Default, title: "Delete",
    //        handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
    //            self.deleteAccount(indexPath)
    //        }
    //    );
    //
    //    return [deleteAction, editAction]
    //}
    
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
    
    // connect to the server..
    func testNewPassword(newPassword: String, indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // implement send data back protocol, if this is the first time user adds an account and if this account can
    // pass the verification, then set this account as the tempUser (i.e., default user account)
    func sendDataBack(tempUser: TempUser) {
        if data.count == 0 {
            myAppBundleHelper.updateTempUser(tempUser)
            self.tempUser = myAppBundleHelper.getTempUser()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(segue.identifier)
        if let tempIdentifier = segue.identifier {
            switch tempIdentifier {
                
            case "AddAccount":
                let destinationViewController = segue.destinationViewController as! AccountManagementViewController
                destinationViewController.sendDataBackDelegate = self
                
            case "ChangeAccount":
                //print("ChangeAccount")
                
                let destinationViewController = segue.destinationViewController as! AccountManagementViewController
                
                if let selectedRow = self.tableView.indexPathForCell(sender as! UITableViewCell)?.row {
                    destinationViewController.passedUsername = data[selectedRow].username
                    destinationViewController.passedPassword = data[selectedRow].password
                    destinationViewController.passedDepartment = data[selectedRow].department
                    destinationViewController.existingAccount = data[selectedRow] as NSManagedObject
                }
                
            default:
                break
            }
        }
    }
    
    func showUpdateTempUser(row: Int) {
        
        let updateMenu = UIAlertController(
            title: "Do you want to set this account as default?",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        updateMenu.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:
            {
                (alertAction: UIAlertAction!) -> Void in
                self.myAppBundleHelper.updateTempUser(TempUser(username: self.data[row].username, password: self.data[row].password, department: self.data[row].department))
                self.tempUser = self.myAppBundleHelper.getTempUser()
                self.tableView.reloadData()
        }))
        
        updateMenu.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(updateMenu, animated: true, completion: nil)
    }
    
}
