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
    @IBOutlet weak var myCollectionView : UICollectionView!
    
    var imagePicker : UIImagePickerController?

    var file : String?
    var section : String?
    var operation : String?
    var images : [UIImage] = [UIImage]()
    var currentImage : String?
    
    override func viewWillAppear(_ animated: Bool) {
        //reading image document
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = documentsFolderPath.appending(fileName.text!)
    
        //loading image
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("Image not available at: \(path)")
        }else{
            images.append(image!)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker =  UIImagePickerController()
        self.imagePicker?.delegate = self
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
        var imagesArray : [[String : String]]
        if(operation == "Create"){
            if Utilities.dictionary[self.sectionName.text!] != nil {
                titlesArray = Utilities.dictionary[self.sectionName.text!] as! [String]
                imagesArray = Utilities.imagesDictionary[self.sectionName.text!] as! [[String : String]]
            } else {
                titlesArray = [String]()
                imagesArray = [[String : String]]()
            }

            titlesArray.append(self.fileName.text!)
            Utilities.dictionary.setValue(titlesArray, forKey: self.sectionName.text!)
            
            if let selectedImage = self.currentImage {
                let img : [String : String] = [
                    "Id" : self.fileName.text!
                    ,"Image" : selectedImage
                ]
                imagesArray.append(img)
            }
            
            Utilities.imagesDictionary.setValue(imagesArray, forKey: self.sectionName.text!)
        } else if self.section != self.sectionName.text {
            var oldTitlesArray : [String]
            var oldImagesArray : [[String : String]]

            //Moving title from Section
            oldTitlesArray = [String]()
            oldImagesArray = [[String : String]]()

            let arrayForSection : [String]    = Utilities.dictionary[self.section!] as! [String]
            let imagesArrayForSection : [[String : String]]   = Utilities.imagesDictionary[self.section!] as! [[String : String]]
            
            for title in arrayForSection {
                if title != self.file {
                    oldTitlesArray.append(title)
                }
            }
            
            for image in imagesArrayForSection {
                if image["Id"] != self.file {
                    let i : [String : String] = [
                        "Id" : image["Id"]!
                        ,"Image" : image["Image"]!
                    ]
                    oldImagesArray.append(i)
                }
            }
            
            //Setting the array back without the edited title
            if oldTitlesArray.count == 0 {
                Utilities.dictionary.removeObject(forKey: self.section!)
                Utilities.imagesDictionary.removeObject(forKey: self.section!)
            } else {
                Utilities.dictionary.setValue(oldTitlesArray, forKey: self.section!)
                Utilities.imagesDictionary.setValue(oldImagesArray, forKey: self.section!)
            }
            
            //Add the title to the new Section
            if Utilities.dictionary[self.sectionName.text!] != nil {
                titlesArray = Utilities.dictionary[self.sectionName.text!] as! [String]
                imagesArray = Utilities.imagesDictionary[self.sectionName.text!] as! [[String : String]]
            } else {
                titlesArray = [String]()
                imagesArray = [[String : String]]()
            }
            titlesArray.append(self.fileName.text!)
            Utilities.dictionary.setValue(titlesArray, forKey: self.sectionName.text!)
            
            let i : [String : String] = [
                "Id" : self.fileName.text!
                ,"Image" : self.currentImage!
            ]
            imagesArray.append(i)
            Utilities.imagesDictionary.setValue(imagesArray, forKey: self.sectionName.text!)
            
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
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.item == images.count{
            self.imagePicker?.sourceType = .photoLibrary
            self.present(imagePicker!, animated: true, completion: nil)
        }else{
            self.currentImage = images[indexPath.row].accessibilityIdentifier
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
}


extension textViewerCVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        let image = cell.viewWithTag(5) as! UIImageView
        
        if indexPath.item == images.count {
            
            image.image = UIImage(named: "add")
            
        } else {
            image.image = images[indexPath.row]
            images[indexPath.row].accessibilityIdentifier = "\(indexPath.row)"
        }
        
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

extension textViewerCVC : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let yourPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(yourPickedImage)
            self.myCollectionView.reloadData()
            print(yourPickedImage)
            
            //saving image document
            let fileManager = FileManager.default
            let paths       = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first)?.appending(fileName.text!)
            let imageData   = UIImageJPEGRepresentation(yourPickedImage, 0.8)
            fileManager.createFile(atPath: paths!, contents: imageData, attributes: nil)
            print("the file was created at path \(paths)")
            

        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        self.dismiss(animated: true, completion: nil)
    }
}

extension textViewerCVC : UINavigationControllerDelegate {
    
}
