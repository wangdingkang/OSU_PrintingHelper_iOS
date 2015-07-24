//
//  PrintingSettingsTableViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/13/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class PrintingSettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, TaskFinishedProtocol {
    
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
    
    @IBOutlet weak var printButton: UIBarButtonItem!
    
    // printers info shown in the pickerView
    var printers = [PrinterInfo]()
    
    var progressView: MyActivityIndicatorView!
    
    var toPrintFoldername: String!
    
    var toPrintFilename: String!
    
    var tempUser: TempUser!
    
    var sshPrintAccountQueue: dispatch_queue_t = dispatch_queue_create("OSU_Printer.NMSSH.print.queue", DISPATCH_QUEUE_SERIAL)
    
    var mySSHHelper: SSHHelper! = SSHHelper.sharedInstance
    
    var myDBHelper: DatabaseHelper! = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // if somethingPrinted, we need to remove its copy on the remote server
    var somethingPrinted = false
    
    // see if it's printing, if yes, we need to ignore other requests.
    var isPrinting = false
    
    // used to get plist info and NSUserDefault info
    let myAppBundleHelper = AppBundleHelper.sharedInstance
    
    // update the textfield of progressView
    func taskFinishedfeedback(feedback: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressView.changeMessage(feedback)
        }
    }
    
    // start printing
    @IBAction func printButtonClicked(sender: UIBarButtonItem) {
        if !isPrinting {
            somethingPrinted = true
            isPrinting = true
            let copies = Int(copiesStepper.value)
            let isDuplex = duplexSwitch.on
            let printerName = printers[printerPickerView.selectedRowInComponent(0)].name
            
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
                }
                else {
                    self.myDBHelper.addAnPrintingHistory(self.toPrintFilename, printedAt: NSDate())
                    self.showPrintSucceedPrompt()
                }
                self.isPrinting = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySSHHelper.taskFinishedDelegate = self
        
        progressView = MyActivityIndicatorView(frame: CGRect(x: 15, y: 15, width: 230, height: 50), message: " ")
        progressView.center = CGPoint(x: self.tableView.bounds.midX, y: self.tableView.bounds.midY)
        
        self.tableView.addSubview(progressView)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tempUser = myAppBundleHelper.getTempUser()
        
        if tempUser != nil {
            departmentLabel?.text = tempUser!.department
            usernameLabel?.text = tempUser!.username
            printers = myAppBundleHelper.getPrinterListByDepartment(Department.allDepartments[Department.getIndexOfRawvalue(tempUser!.department)])
            
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
        //if tempUser != nil && somethingPrinted{
        //   mySSHHelper.removeFileAtPath(toPrintFilename)
        //}
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
            dispatch_async(dispatch_get_main_queue()) {
                let errorMenu = UIAlertController(title: error,
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                errorMenu.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(errorMenu, animated: true, completion: nil)
            }
        }
    }
    
    func showPrintSucceedPrompt() {
        if (self.isViewLoaded() && self.view.window != nil) {
            dispatch_async(dispatch_get_main_queue()) {
                let successMenu = UIAlertController(title: "Nailed it! Go and get your documents!",
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                successMenu.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(successMenu, animated: true, completion: nil)
            }
        }
    }
    
    func showNoValidAccountAlert() {
        let noValidAccountMenu = UIAlertController(
            title: "You haven't set a valid account, please tap the \"Account\" tab and set your first account😉",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        noValidAccountMenu.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(noValidAccountMenu, animated: true, completion: nil)
    }
    
    
}
