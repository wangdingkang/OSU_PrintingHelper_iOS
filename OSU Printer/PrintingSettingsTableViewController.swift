//
//  PrintingSettingsTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class PrintingSettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, TaskFinishedProtocol {
    
    let heightForFooter = CGFloat(50.0)
    
    let componentOfPicker = 1
    
    @IBOutlet weak var duplexSwitch: UISwitch!
    
    @IBOutlet weak var copiesStepper: UIStepper!
    
    @IBAction func copiesStepperValueChanged(sender: UIStepper) {
        let tempValue = Int(sender.value)
        if tempValue == 1 {
            copiesLabel.text = "\(tempValue) copy"
        } else {
            copiesLabel.text = "\(tempValue) copies"
        }
    }
    
    @IBOutlet weak var copiesLabel: UILabel!
    
    @IBOutlet weak var printerPickerView: UIPickerView!
    
    @IBOutlet weak var printerDescriptionLabel: UILabel!
    
    @IBOutlet weak var departmentLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var progressView: MyActivityIndicatorView!
    
    var toPrintFoldername: String!
    
    var toPrintFilename: String!
    
    var tempUser: TempUser!
    
    var sshPrintAccountQueue: dispatch_queue_t = dispatch_queue_create("OSU_Printer.NMSSH.print.queue", DISPATCH_QUEUE_SERIAL)
    
    var mySSHHelper: SSHHelper!
    
    var myDBHelper: DatabaseHelper!
    
    var somethingPrinted = false
    
    var isPrintingStarted = false
    
    @IBOutlet weak var printButton: UIBarButtonItem!
    
    func taskFinishedfeedback(feedback: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressView.changeMessage(feedback)
        }
    }
    
    @IBAction func printButtonClicked(sender: UIBarButtonItem) {
        if !isPrintingStarted {
            somethingPrinted = true
            isPrintingStarted = true
            let copies = Int(copiesStepper.value)
            let isDuplex = duplexSwitch.on
            let printerName = printers[printerPickerView.selectedRowInComponent(0)].name
            print("Print \(copies) copy(s) by \(printerName) \(isDuplex) duplex\n")
            
            progressView.startAnimating()
            progressView.changeMessage("...")
            dispatch_async(sshPrintAccountQueue) {
                
                () -> Void in
                var error: String?
                self.mySSHHelper.printPDF(self.tempUser, sourceFoldername: self.toPrintFoldername, sourceFilename: self.toPrintFilename, printingOption: PrintingOption(printerName: printerName, copies: copies, isDuplex: isDuplex), error: &error)
                
                dispatch_sync(dispatch_get_main_queue()) {
                    self.progressView.stopAnimating()
                }
                
                if error != nil {
                    self.showErrorWhenPrintAlert(error!)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showErrorWhenPrintAlert(error!)
                        self.isPrintingStarted = false
                    }
                }
                else {
                    self.myDBHelper.addAnPrintingHistory(self.toPrintFilename, printedAt: NSDate())
                    dispatch_async(dispatch_get_main_queue()) {
                        () -> Void in
                        self.showPrintSucceedPrompt()
                        self.isPrintingStarted = false
                    }

                }
            }
        }
    }
    
    var printers = [PrinterInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySSHHelper = SSHHelper.sharedInstance
        mySSHHelper.taskFinishedDelegate = self
        
        if myDBHelper == nil {
            myDBHelper = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
        }
        
        progressView = MyActivityIndicatorView(frame: CGRect(x: 15, y: 15, width: 230, height: 50), message: " ")
        
        progressView.center = CGPoint(x: self.tableView.bounds.midX, y: self.tableView.bounds.midY)
        
        self.tableView.addSubview(progressView)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tempUser = LocalFileHelper.getTempUser()
        
        if tempUser != nil {
            
            departmentLabel?.text = tempUser!.department
            usernameLabel?.text = tempUser!.username
            
            printers = LocalFileHelper.getPrinterListByDepartment(Department.allDepartments[Department.getIndexOfRawvalue(tempUser!.department)])
            
            if printers.count != 0 {
                printerDescriptionLabel.text = "A \(printers[0].type) printer located in \(printers[0].location) \n"
            }
            
        } else {
            departmentLabel?.text = " "
            printerDescriptionLabel?.text = " "
            printers = [PrinterInfo]()
            printButton.enabled = false
        }
        printerPickerView.reloadAllComponents()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if tempUser == nil {
            showNoValidAccountAlert()
        }
    }
    
    deinit {
        if tempUser != nil && somethingPrinted{
            mySSHHelper.removeFileAtPath(toPrintFilename)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        //print("Show row \(row) \n")
        return printers[row].name
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return data.count
        return printers.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        //return numberOfComponents
        return componentOfPicker
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("Changed to \(row) \n")
        if printers.count != 0 {
            printerDescriptionLabel.text = "A \(printers[row].type) printer located in \(printers[row].location)"
        }
    }
    
    func showErrorWhenPrintAlert(error: String) {
        if (self.isViewLoaded() && self.view.window != nil) {
            let errorMenu = UIAlertController(title: "Alert",
                message: error,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            errorMenu.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(errorMenu, animated: true, completion: nil)
        }
    }
    
    func showPrintSucceedPrompt() {
        if (self.isViewLoaded() && self.view.window != nil) {
            let successMenu = UIAlertController(title: "Nailed it!",
                message: "go and get your documents!",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            successMenu.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(successMenu, animated: true, completion: nil)
        }
    }
    
    func showNoValidAccountAlert() {
        if (self.isViewLoaded() && self.view.window != nil) {
            let noValidAccountMenu = UIAlertController(
                title: "Alert",
                message: "You haven't set a valid account, please tap the \"Account\" tab and set your first account😉",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            noValidAccountMenu.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(noValidAccountMenu, animated: true, completion: nil)
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
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
