//
//  ViewController.swift
//  First Class
//
//  Created by Victor Cabrales on 8/26/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit
import CoreText

class ViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    
    var dictionary : NSMutableDictionary = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSBundle.mainBundle().URLForResource("menu", withExtension: "json")
        
        if url != nil {
            readURLFile(url!)
        }else{
            createJSONMenu()
        }
    }
    
    func readURLFile(url: AnyObject){
    
        let data = NSData(contentsOfURL: url as! NSURL)
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(dictionary)
            }
            } catch {
                print("error serializing JSON: \(error)")
            }
    }
    
    func createJSONMenu(){
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        let jsonFilePath = documentsDirectoryPath.URLByAppendingPathComponent("menu.json")
        let fileManager = NSFileManager.defaultManager()
        var isDirectory: ObjCBool = false
        
        // creating a .json file in the Documents folder
        if !fileManager.fileExistsAtPath(jsonFilePath.absoluteString, isDirectory: &isDirectory) {
            let created = fileManager.createFileAtPath(jsonFilePath.absoluteString, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
        } else {
            print("File already exists")
        }
        
        let jsonObject: [String: AnyObject] = [
            "menu": [
                "Section": "White Belt"
                ,"Titles" : [
                    "Title": "Conceptos basicos",
                    "Title": "Conceptos basicos II",
                    "Title": "Frank no vino",
                    "Title": "Navegacion basica"
                ]
    
            ],
                "Section": "Test"
            ,"Titles" : [
                "Title": "test"
            ]
        ]
        
        
        // creating JSON out of the above array
        var jsonData: NSData!
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions())
            let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding)
            print(jsonString)
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        // Write that JSON to the file created earlier
        let jsonFilePath2 = documentsDirectoryPath.URLByAppendingPathComponent("menu.json")
        do {
            let file = try NSFileHandle(forWritingToURL: jsonFilePath2)
            file.writeData(jsonData)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
        
        readURLFile(jsonFilePath2)
    }
    
    

    func readJSONObject(object: [String: AnyObject]) {
        guard let menu = object["menu"] as? [[String: AnyObject]] else { return }
        
        for section in menu {
            let name = section["Section"] as? String
            print(name)
            let titles = section["Titles"] as? [[String: AnyObject]]
           
            var titlesArray = [String]()
            
            for title in titles! {
                titlesArray.append(title["Title"] as! String)
            }
            self.dictionary.setValue(titlesArray, forKey: name!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let currentCell : customTVC = tableView.cellForRowAtIndexPath(indexPath) as! customTVC
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let sectionName : String = self.dictionary.allKeys[indexPath.section] as! String
        let cellTitle   : String = (self.dictionary[sectionName] as! [String])[indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewControllerWithIdentifier("textViewerCVC") as! textViewerCVC
        
        controller.file = cellTitle
        controller.section = sectionName
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName : String = self.dictionary.allKeys[section] as! String
        return sectionName
    }
    

}

extension ViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dictionary.allKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey : String = self.dictionary.allKeys[section] as! String //
        let arrayForSection     = self.dictionary[sectionKey] //White belt, etc...
        
        return arrayForSection!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customTVC
        
        let sectionKey : String = self.dictionary.allKeys[indexPath.section] as! String
        let arrayForSection : [String]    = self.dictionary[sectionKey] as! [String]

        cell.myImage.image = UIImage(named : "icon")
        cell.myTitle.text = arrayForSection[indexPath.row]
        cell.mySubtitle.text = ""

        return cell
    }

    @IBAction func addNote(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewControllerWithIdentifier("textViewerCVC") as! textViewerCVC
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}