//
//  AccountManagementViewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/14/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit
import CoreData

class AccountManagementViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var departmentPicker: UIPickerView!
    
    var data = Department.allDepartments
    
    let numberOfComponents = 1
    
    // if cancell button is clicked, we don't need to update the datebase
    var isCancelled = false
    
    // if it's saving an account, we won't response to other saving requests
    var isSaving = false
    
    var passedUsername: String?
    
    var passedPassword: String?
    
    var passedDepartment: String?
    
    var existingAccount: NSManagedObject?
    
    @IBOutlet weak var sshProgressIndicator: UIActivityIndicatorView!
    
    var myDBHelper: DatabaseHelper = DatabaseHelper(appDelegate: UIApplication.sharedApplication().delegate as! AppDelegate)
    
    var mySSHHelper: SSHHelper = SSHHelper.sharedInstance
    
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
                    else if !self.isCancelled{
                        
                        // change an existing accout
                        if self.existingAccount != nil {
                            self.myDBHelper.changeAnAccount(username, password: password, department: department, existingUser: self.existingAccount!)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                        }
                            
                        // add a new account
                        else {
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
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.sshProgressIndicator.stopAnimating()
                }
                self.isSaving = false
            }
        }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        isCancelled = true
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordField.delegate = self
        
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if usernameTextField.editing{
            passwordField.becomeFirstResponder()
        } else if passwordField.editing {
            passwordField.endEditing(true)
        }
        return true
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
                    title: "Your username or password should not be empty",
                    message: "",
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
                    title: "This account has existed in the list, you can change it instead",
                    message: "",
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
                    title: connectionError,
                    message: "",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
}
