//
//  DatabaseHelper.swift
//
//
//  Created by Dingkang Wang on 7/14/15.
//
//

import Foundation
import CoreData


/**
    This class is used to help the AccountsTableView to get the added accounts, change the stored accounts,
    and delete some account, haven't dealt with exceptions yet.
*/
class DatabaseHelper{
    
    weak var context: NSManagedObjectContext!
    
    let entityNameForAccount = "Account"
    let keyUsernameInAccount = "username"
    let keyPasswordInAccount = "password"
    let keyDepartmentInAccount = "department"
    
    
    let entityNameForPrintingHistory = "PrintingHistory"
    let keyFilenameInPrintingHistory = "filename"
    let keyPrintedAtInPrintingHistory = "printedAt"
    
    init(appDelegate: AppDelegate) {
        context = appDelegate.managedObjectContext
    }
    
    // MARK: functions about entity: Account
    
    func queryAllAccounts() -> [AnyObject]? {
        let fetch = NSFetchRequest(entityName: entityNameForAccount)
        let res = context.executeFetchRequest(fetch, error: nil)
        return res
    }
    
    func doesAccountExists(username: String, department: String) -> Bool {
        let fetch = NSFetchRequest(entityName: entityNameForAccount)
        fetch.predicate = NSPredicate(format: "\(keyUsernameInAccount) == %@ AND \(keyDepartmentInAccount) == %@", argumentArray: [username, department])
        let res = context.executeFetchRequest(fetch, error: nil)
        if res == nil {
            return false
        }
        return (res!.count == 0) ? false : true
    }
    
    func addAnAccount(username: String, password: String, department: String) -> Void {
        let en = NSEntityDescription.entityForName(entityNameForAccount, inManagedObjectContext: context)
        if (en != nil) {
            var newAccount = Account(entity: en!, insertIntoManagedObjectContext: context)
            newAccount.username = username
            newAccount.password = password
            newAccount.department = department
            context.save(nil)
            
        } else{
            // some error
            
        }
    }
    
    func changeAnAccount(username: String, password: String, department: String, existingUser: NSManagedObject) -> Void {
        existingUser.setValue(username, forKey: keyUsernameInAccount)
        existingUser.setValue(password, forKey: keyPasswordInAccount)
        existingUser.setValue(department, forKey: keyDepartmentInAccount)
        context.save(nil)
    }
    
    func deleteAnAccount(willDeleteUser: NSManagedObject) -> Void {
        context.deleteObject(willDeleteUser)
        var error: NSError? = nil
        if !context.save(&error) {
            abort()
        }
    }
    
    
    // MARK: functions about entity: PrintingHistory
    
    func queryAllPrintingHistories() -> [AnyObject]? {
        let fetch = NSFetchRequest(entityName: entityNameForPrintingHistory)
        let res = context.executeFetchRequest(fetch, error: nil)
        return res
    }
    
    func addAnPrintingHistory(filename: String, printedAt: NSDate) {
        let en = NSEntityDescription.entityForName(entityNameForPrintingHistory, inManagedObjectContext: context)
        if (en != nil) {
            var printingHistory = PrintingHistory(entity: en!, insertIntoManagedObjectContext: context)
            printingHistory.filename = filename
            printingHistory.printedAt = printedAt
            context.save(nil)
        } else{
            // some error
            
        }
    }
    
    func deleteAnPrintingHistory(willDeleteHistory: NSManagedObject) -> Void {
        context.deleteObject(willDeleteHistory)
        var error: NSError? = nil
        if !context.save(&error) {
            abort()
        }
    }
    
}