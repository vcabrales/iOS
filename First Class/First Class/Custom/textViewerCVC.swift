//
//  textViewerCVC.swift
//  First Class
//
//  Created by Victor Cabrales on 9/1/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class textViewerCVC: UIViewController {

    
    @IBOutlet weak var MyScrollView: UIScrollView!
    @IBOutlet weak var myContent: UITextView!
    @IBOutlet weak var sectionName: UITextField!
    @IBOutlet weak var fileName: UITextField!

    var file : String?
    var section : String?
    var operation : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionName.becomeFirstResponder()
        
        self.sectionName.text = section
        self.fileName.text = file

        if operation != "Create" {
            readFile()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNote(_ sender: AnyObject) {
        let pathForTheFile = getFilePath()
        
        do{
            try self.myContent.text.write(toFile: pathForTheFile, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            print(error)
        }
        
        if(operation == "Create"){
            let controller = self.presentingViewController as! ViewController
            var titlesArray : [String]
            if Utilities.dictionary[self.sectionName.text!] != nil {
                titlesArray = Utilities.dictionary[self.sectionName.text!] as! [String]
            } else {
                titlesArray = [String]()
            }

            titlesArray.append(self.fileName.text!)
            Utilities.dictionary.setValue(titlesArray, forKey: self.sectionName.text!)
            print(Utilities.dictionary)
            controller.reloadData()
            Utilities.createMenu()
        }
        
        operation = ""
        
        // Dismiss the modal controller
        self.dismiss(animated: true, completion: nil)
    }
    
    func readFile(){
        let pathForTheFile = getFilePath()
        
        do{
            let contents = try NSString(contentsOfFile: pathForTheFile, encoding: String.Encoding.ascii.rawValue) as String
            self.myContent.text = contents
        }catch{
            print(error)
        }
    }
    
    func getFilePath() -> String {
        var plistPathInDocument:String = String()
        
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        
        plistPathInDocument = rootPath + ("/" + (self.fileName.text!) + ".strings")
        
        return plistPathInDocument

    }
}

extension textViewerCVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage = textField.tag + 1;
        
        if(nextTage == 1){
            textField.superview?.viewWithTag(nextTage)?.becomeFirstResponder()
        }else if (nextTage == 2){
            myContent.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
}

extension textViewerCVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let containerText = textView.text
        
        if(containerText == "Your Text Here..."){
            textView.text.removeAll()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            saveNote("Create" as AnyObject)
        }
        return true
    }

}
