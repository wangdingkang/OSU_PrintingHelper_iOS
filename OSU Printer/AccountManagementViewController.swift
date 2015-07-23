//
//  AccountManagementViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/14/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit
import CoreData

class AccountManagementViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var departmentPicker: UIPickerView!
    
    var data = Department.allDepartments
    
    let numberOfComponents = 1
    
    var isCancelled = false
    
    var isSaving = false
    
    var passedUsername: String?
    
    var passedPassword: String?
    
    var passedDepartment: String?
    
    @IBOutlet weak var sshProgressIndicator: UIActivityIndicatorView!
    
    var existingAccount: NSManagedObject?
    
    var myDBHelper: DatabaseHelper!
    
    var mySSHHelper: SSHHelper!
    
    weak var sendDataBackDelegate: SendDataBackProtocol!
    
    var sshTestAccountQueue: dispatch_queue_t = dispatch_queue_create("OSU_Printer.NMSSH.test.queue", DISPATCH_QUEUE_SERIAL)
    
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        if !isSaving {
            isSaving = true
            sshProgressIndicator.hidden = false
            sshProgressIndicator.startAnimating()
            
            dispatch_async(sshTestAccountQueue) {
                
                () -> Void in
                
                let username = self.usernameTextField.text
                let password = self.passwordField.text
                let department = self.data[self.departmentPicker.selectedRowInComponent(0)].rawValue
                if username.isEmpty || password.isEmpty || department.isEmpty{
                    self.showSomethingEmptyAlert()
                }
                else if self.myDBHelper.doesAccountExists(username, department: department) && (username != self.passedUsername || department != self.passedDepartment){
                    self.showAccountExistedAlert()
                }
                else {
                    var error: String?
                    
                    self.mySSHHelper.testUsernameAndPassword(TempUser(username: username, password: password, department: department), error: &error)
                    
                    if error != nil {
                        self.showSSHConnectionErrorAlert(error!)
                    }
                    else {
                        if self.existingAccount != nil {
                            // change an existing accout
                            if !self.isCancelled {
                                self.myDBHelper.changeAnAccount(username, password: password, department: department, existingUser: self.existingAccount!)
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                }
                            }
                        } else {
                            // add a new account
                            if !self.isCancelled {
                                self.myDBHelper.addAnAccount(username, password: password, department: department)
                                if self.sendDataBackDelegate != nil {
                                    self.sendDataBackDelegate!.sendDataBack(TempUser(username: username, password: password, department: department))
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.navigationController?.popToRootViewControllerAnimated(true)
                                    }
                                }
                            }
                        }
                    }
                }
                self.isSaving = false
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.sshProgressIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        isCancelled = true
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init my DBHelper
        myDBHelper = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
        
        // init my SSHHelper
        mySSHHelper = SSHHelper.sharedInstance
        
        if passedUsername != nil {
            usernameTextField.text = passedUsername
            passwordField.text = passedPassword
            departmentPicker.selectRow(Department.getIndexOfRawvalue(passedDepartment!), inComponent: 0, animated: false)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        dispatch_async(sshTestAccountQueue) {
            Void -> () in
            self.mySSHHelper.releaseConnection()
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func showSomethingEmptyAlert() {
        if (self.isViewLoaded() && self.view.window != nil) {
            dispatch_async(dispatch_get_main_queue()) {
                
                () -> Void in
                
                let emptyAlert = UIAlertController(
                    title: "Alert",
                    message: "Your username or password should not be empty",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(emptyAlert, animated: true, completion: nil)
            }
        }
    }
    
    func showAccountExistedAlert() {
        
        if (self.isViewLoaded() && self.view.window != nil) {
            dispatch_async(dispatch_get_main_queue()) {
                
                () -> Void in
                
                let emptyAlert = UIAlertController(
                    title: "Alert",
                    message: "This account has existed in the list, you can change it instead",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(emptyAlert, animated: true, completion: nil)
            }}
    }
    
    func showSSHConnectionErrorAlert(connectionError: String) {
        
        if (self.isViewLoaded() && self.view.window != nil) {
            dispatch_async(dispatch_get_main_queue()) {
                () -> Void in
                let errorAlert = UIAlertController(
                    title: "Alert",
                    message: connectionError,
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }}
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
