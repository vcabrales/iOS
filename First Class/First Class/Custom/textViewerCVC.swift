//
//  textViewerCVC.swift
//  First Class
//
//  Created by Victor Cabrales on 9/1/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class textViewerCVC: UIViewController {

    
    @IBOutlet weak var myContent: UITextView!
    @IBOutlet weak var sectionName: UITextField!
    @IBOutlet weak var fileName: UITextField!

    var file : String?
    var section : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sectionName.text = section
        self.fileName.text = file

        readFile()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveNote(sender: AnyObject) {
        let pathForTheFile = getFilePath()
        
        do{
            try self.myContent.text.writeToFile(pathForTheFile, atomically: true, encoding: NSUTF8StringEncoding)
        }catch{
            print(error)
        }
        // Dismiss the modal controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func readFile(){
        let pathForTheFile = getFilePath()
        
        do{
            let contents = try NSString(contentsOfFile: pathForTheFile, encoding: NSASCIIStringEncoding) as String
            self.myContent.text = contents
        }catch{
            print(error)
        }
    }
    
    func getFilePath() -> String {
        var plistPathInDocument:String = String()
        
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        
        plistPathInDocument = rootPath.stringByAppendingString("\(self.sectionName.text)-\(self.fileName.text).strings")
        return plistPathInDocument

    }
}