//
//  LocalFileReader.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/18/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

class LocalFileHelper {
    
    static var printerDictionary: NSDictionary?
    
    static var tempUser: TempUser?
    
    private static var keyForTempUser = "temp_user"
    
    // Something about the app's plists
    
    static func loadPrinterDictionary() {
        if let path = NSBundle.mainBundle().pathForResource("Resource", ofType: "plist") {
            if let tempDictionary = NSDictionary(contentsOfFile: path) {
                print("Loaded printer dict\n")
                printerDictionary = tempDictionary.objectForKey("Printers") as? NSDictionary
            }
        }
    }
    
    static func getPrinterListByDepartment(department: Department) -> [PrinterInfo]{
        if printerDictionary == nil {
            loadPrinterDictionary()
        }
        var ret = [PrinterInfo]()
        var csePrinters: [NSDictionary]?
        switch department {
        case Department.CSE:
            csePrinters = printerDictionary?.objectForKey("CSE") as? [NSDictionary]
        case Department.ECE:
            csePrinters = printerDictionary?.objectForKey("ECE") as? [NSDictionary]
        default:
            break
        }
        if csePrinters != nil {
            for onePrinterDictionary in csePrinters! {
                let name = onePrinterDictionary.valueForKey("name") as? String
                let location = onePrinterDictionary.valueForKey("location") as? String
                let type = onePrinterDictionary.valueForKey("type") as? String
                
                if name != nil && location != nil && type != nil {
                    ret.append(PrinterInfo(name: name!, location: location!, type: type!))
                }
            }
        }
        return ret
    }
    
    // Something about the NSUserDefaults
    
    static func loadTempUser() {
        if let tempData = NSUserDefaults.standardUserDefaults().dataForKey(keyForTempUser) {
            tempUser = NSKeyedUnarchiver.unarchiveObjectWithData(tempData) as? TempUser
        }
    }
    
    static func getTempUser() -> TempUser? {
        if tempUser == nil {
            loadTempUser()
        }
        return tempUser
    }
    
    static func updateTempUser(tempUser: TempUser) {
        print("UPDATE TEMPUSER \(tempUser.username) \n")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let tempData = NSKeyedArchiver.archivedDataWithRootObject(tempUser)
        userDefaults.setObject(tempData, forKey: keyForTempUser)
        userDefaults.synchronize()
        loadTempUser()
    }
    
    static func removeTempUser() {
        print("Remove TempUser \n")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(keyForTempUser)
        userDefaults.synchronize()
        tempUser = nil
    }
    
}