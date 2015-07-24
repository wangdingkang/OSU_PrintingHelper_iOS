//
//  PreviewController.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/24/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
    
    @IBOutlet weak var previewWebView: UIWebView!
    
    var myFile: DocumentFile!
    
    var myFileSystemHelper = FileSystemHelper()
    
    let filesizeLimit: UInt64 = 10 * 1024 * 1024 // 10 MB
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var isSomethingLoaded = false
        if myFile.filesize <= filesizeLimit {
            if let url = myFileSystemHelper.getNSURLFromFilename(myFile.filename) {
                let request = NSURLRequest(URL: url)
                previewWebView.loadRequest(request)
                isSomethingLoaded = true
            }
        }
        if !isSomethingLoaded {
        // maybe show a default page saying your file is too large to show in this web view or something.
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tempIdentifier = segue.identifier {
            switch tempIdentifier {
            case "ToPrintIdentifier":
                let destinationViewController = segue.destinationViewController as! PrintingSettingsTableViewController
                destinationViewController.toPrintFile = myFile
                destinationViewController.toPrintFoldername = myFileSystemHelper.DocumentsRootPath
            default:
                break
            }
        }
    }
    
}
