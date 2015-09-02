//
//  SSHHelper.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/16/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

class SSHHelper {
    
    static let sharedInstance = SSHHelper()
    
    var tempSession: NMSSHSession!
    
    var tempFTPConnection: NMSFTP!
    
    var tempUser: TempUser?
    
    // try to connect to different servers in order to avoid frozen.
    let hostnameForCSE = "gamma.cse.ohio-state.edu"
    
    let hostnameForECE = "rh026.ece.ohio-state.edu"
    
    let serverTempFolderPath = "temp_print"
    
    let removeFileCommand = "rm"
    
    let mkdirCommand = "mkdir temp_print"
    
    let fitToPageCommand = " -o fit-to-page "
    
    let twoSidedCommand = " -o sides=two-sided-long-edge "
    
    weak var taskFinishedDelegate: TaskFinishedProtocol!
    
    let sshCommandQueue: dispatch_queue_t = dispatch_queue_create("OSU_Printer.NMSSH.command.queue", DISPATCH_QUEUE_SERIAL)
    
    let sshTestQueue: dispatch_queue_t = dispatch_queue_create("OSU_Printer.NMSSH.test.queue", DISPATCH_QUEUE_SERIAL)
    
    let sshSemaphore = dispatch_semaphore_create(1)
    
    private init() {}
    
    // change the way to get print commands.
    // add fit in one page command for printing images.
    private func getPrintCommand(printingOption: PrintingOption, filename: String) -> String {
        var res = "lp -d \(printingOption.printerName)"
        if printingOption.isDuplex {
            res += twoSidedCommand
        }
        if printingOption.isFitOnePage {
            res += fitToPageCommand
        }
        res += " -n \(printingOption.copies) \"\(filename)\""
        return res
        //        return printingOption.isDuplex ? "lp -d \(printingOption.printerName) -o sides=two-sided-long-edge -n \(printingOption.copies) \"\(filename)\"" :
        //        "lp -d \(printingOption.printerName) -n \(printingOption.copies) \"\(filename)\""
    }
    
    private func createANewSession(tempUser: TempUser, inout error: String?){
        var hostname: String?
        switch tempUser.department {
        case Department.CSE.rawValue:
            hostname = self.hostnameForCSE
        case Department.ECE.rawValue:
            hostname = self.hostnameForECE
        default:
            break
        }
        if hostname != nil {
            tempSession = NMSSHSession(host: hostname, andUsername: tempUser.username)
            // set timeout to be 2 seconds
            tempSession.connectWithTimeout(2)
            if !tempSession.connected {
                error = "Connection error, please check you internet connection."
            } else {
                tempSession.authenticateByPassword(tempUser.password)
                if !tempSession.authorized {
                    error = "Invalid username or password."
                } else {
                    self.tempUser = tempUser
                    tempSession.channel.requestPty  = true
                    tempSession.channel.ptyTerminalType = NMSSHChannelPtyTerminal.VT100
                }
            }
        } else {
            error = "No hostname found."
        }
    }
    
    func testUsernameAndPassword(newUser: TempUser, inout error: String?) {
        dispatch_semaphore_wait(sshSemaphore, DISPATCH_TIME_FOREVER)
        if !isTempSessionActive(newUser){
            if tempSession != nil && tempSession.connected{
                tempSession?.disconnect()
            }
            createANewSession(newUser, error: &error)
        }
        dispatch_semaphore_signal(sshSemaphore)
    }
    
    private func isTempSessionActive(newUser: TempUser) -> Bool {
        return tempUser != nil && tempUser!.isEqual(newUser) && tempSession != nil && tempSession.authorized
    }
    
    private func createFolderAndUploadFileToServer(foldername: String, filename: String, inout error: String?) {
        tempFTPConnection = NMSFTP(session: tempSession)
        tempFTPConnection.connect()
        
        if !tempFTPConnection.directoryExistsAtPath(serverTempFolderPath + "/") {
            tempFTPConnection.createDirectoryAtPath(serverTempFolderPath + "/")
        }
        
        let fromPath = foldername.stringByAppendingPathComponent(filename)
        let toPath = serverTempFolderPath.stringByAppendingPathComponent(filename)
        
        let uploadOK = tempFTPConnection.writeFileAtPath(foldername.stringByAppendingPathComponent(filename), toFileAtPath:
            "\(serverTempFolderPath.stringByAppendingPathComponent(filename))")
        
        tempFTPConnection.disconnect()
        if !uploadOK {
            error = "Some errors happen when uploading your file"
        }
    }
    
    func printFile(newUser: TempUser, sourceFoldername: String, sourceFile: DocumentFile, printingOption: PrintingOption, inout error: String?) {
        dispatch_semaphore_wait(sshSemaphore, DISPATCH_TIME_FOREVER)
        taskFinishedDelegate.taskFinishedfeedback("Checking...")
        // There is a bug in version 1.1.0, we need to disconnect manually and reconnect.
        // Sometimes, the connection will be lost and the return value of session.authority is still true.
        
        //    if !isTempSessionActive(newUser) {
        //        // create a new session
        //        if tempSession != nil {
        //            tempSession?.disconnect()
        //        }
        
        if tempSession != nil {
            tempSession.disconnect()
        }
        createANewSession(newUser, error: &error)
        if error != nil {
            dispatch_semaphore_signal(sshSemaphore)
            return
        }
        
        //    }
        taskFinishedDelegate.taskFinishedfeedback("Creating temp folder on server...")
        
        if error == nil {
            taskFinishedDelegate.taskFinishedfeedback("Start uploading...")
            createFolderAndUploadFileToServer(sourceFoldername, filename: sourceFile.filename, error: &error)
            if error == nil {
                taskFinishedDelegate.taskFinishedfeedback("Start printing...")
                switch sourceFile.fileType {
                case .DOC, .DOCX :
                    executePrintDocs(sourceFile.filename, printingOption: printingOption, error: &error)
                default:
                    executePrintDefault(sourceFile.filename, printingOption: printingOption, error: &error)
                }
            }
        }
        
        dispatch_semaphore_signal(sshSemaphore)
    }
    
    var printed = 0
    
    private func executePrintDocs(filename: String, printingOption: PrintingOption, inout error: String?) {
        if tempSession == nil || !tempSession.connected {
            error = "Connection unexpectedly interrupted."
            return
        }
        let cdInCommand = "cd temp_print; "
        let conversionCommand = "soffice --headless --convert-to pdf \"\(filename)\"; "
        let printCommand = getPrintCommand(printingOption, filename: filename.stringByDeletingPathExtension + ".pdf") + "; "
        let cdOutCommand = "cd ../"
        let command = cdInCommand + conversionCommand + printCommand + cdOutCommand
        
        tempSession.channel.execute(cdInCommand + conversionCommand + printCommand + cdOutCommand, error: nil)
        //print("\(command) \n")
    }
    
    private func executePrintDefault(filename: String, printingOption: PrintingOption, inout error: String?) {
        if tempSession == nil || !tempSession.connected {
            error = "Connection unexpectedly interrupted."
            return
        }
        
        let command = getPrintCommand(printingOption, filename: serverTempFolderPath.stringByAppendingPathComponent(filename))
        
        tempSession.channel.execute(command, error: nil)
        //print("\(command) \n")
    }
    
    func removeFileAtPath(filename: String) {
        dispatch_semaphore_wait(sshSemaphore, DISPATCH_TIME_FOREVER)
        if tempSession != nil && tempSession.connected {
            let command = "\(removeFileCommand) \(serverTempFolderPath.stringByAppendingPathComponent(filename))"
            tempSession.channel.execute(command, error: nil)
        }
        dispatch_semaphore_signal(sshSemaphore)
    }
    
    
    func releaseConnection() {
        dispatch_semaphore_wait(sshSemaphore, DISPATCH_TIME_FOREVER)
        if tempSession != nil{
            tempSession.disconnect()
            tempSession = nil
        }
        dispatch_semaphore_signal(sshSemaphore)
    }
    
}