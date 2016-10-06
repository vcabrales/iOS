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
    var images = [#imageLiteral(resourceName: "document"), #imageLiteral(resourceName: "mail"), #imageLiteral(resourceName: "tablet"), #imageLiteral(resourceName: "user-1"), #imageLiteral(resourceName: "cloud-computing")]
    var currentImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sectionName.text = section
        self.fileName.text = file

        if operation != "Create" {
            myContent.becomeFirstResponder()
            readFile()
        }
        
        sectionName.becomeFirstResponder()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        
        var titlesArray : [String]
        var imagesArray : [AnyObject]
        if(operation == "Create"){
            if Utilities.dictionary[self.sectionName.text!] != nil {
                titlesArray = Utilities.dictionary[self.sectionName.text!] as! [String]
                imagesArray = Utilities.imagesDictionary[self.sectionName.text!] as! [AnyObject]
            } else {
                titlesArray = [String]()
                imagesArray = [AnyObject]()
            }

            titlesArray.append(self.fileName.text!)
            Utilities.dictionary.setValue(titlesArray, forKey: self.sectionName.text!)
            
            let img : [String : String] = [
                "Id" : self.fileName.text!
                ,"Image" : self.currentImage!
            ]
            imagesArray.append(img as AnyObject)
            Utilities.imagesDictionary.setValue(imagesArray, forKey: self.sectionName.text!)
        } else if self.section != self.sectionName.text {
            var oldTitlesArray : [String]

            //Moving title from Section
            oldTitlesArray = [String]()

            let arrayForSection : [String]    = Utilities.dictionary[self.section!] as! [String]
            
            for title in arrayForSection {
                if title != self.file {
                    oldTitlesArray.append(title)
                }
            }
            //Setting the array back without the edited title
            if oldTitlesArray.count == 0 {
                Utilities.dictionary.removeObject(forKey: self.section!)
            } else {
                Utilities.dictionary.setValue(oldTitlesArray, forKey: self.section!)
            }
            
            //Add the title to the new Section
            if Utilities.dictionary[self.sectionName.text!] != nil {
                titlesArray = Utilities.dictionary[self.sectionName.text!] as! [String]
            } else {
                titlesArray = [String]()
            }
            titlesArray.append(self.fileName.text!)
            Utilities.dictionary.setValue(titlesArray, forKey: self.sectionName.text!)
        } else if self.file != self.fileName.text {
            //Just rename the Title
            titlesArray = [String]()

            let arrayForSection : [String]    = Utilities.dictionary[self.section!] as! [String]

            //Renaming title from Section
            for title in arrayForSection {
                if title != self.fileName.text {
                    titlesArray.append(title)
                } else {
                    titlesArray.append(self.fileName.text!)
                }
            }
            Utilities.dictionary.setValue(titlesArray, forKey: self.section!)
        }
        
        let controller = self.presentingViewController as! ViewController
        controller.reloadData()
        Utilities.createMenu()
        
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // This is the point to scroll
        
        if(textField == fileName){
            let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y)
            self.MyScrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Scroll back
        self.MyScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}

extension textViewerCVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let containerText = textView.text
        
        if(containerText == "Your Text Here..."){
            textView.text.removeAll()
        }
        
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            let scrollPoint = CGPoint(x: 0, y: (textView.frame.origin.y) - 0)
            self.MyScrollView.setContentOffset(scrollPoint, animated: true)
        }
        else
        {
            let scrollPoint = CGPoint(x: 0, y: (textView.frame.origin.y) - 60)
            self.MyScrollView.setContentOffset(scrollPoint, animated: true)
        }

        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.MyScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    

}

extension textViewerCVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.currentImage = images[indexPath.row].accessibilityIdentifier
    }    
}


extension textViewerCVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        let image = cell.viewWithTag(5) as! UIImageView
        image.image = images[indexPath.row]
        images[indexPath.row].accessibilityIdentifier = "\(indexPath.row)"
        
        return cell
    }
}

extension textViewerCVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 4) - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.2
    }

}
