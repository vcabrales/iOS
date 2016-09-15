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
    
    //var dictionary : NSMutableDictionary = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("menu.json")
            
            //reading
            do {
                
                let data = NSData(contentsOfURL: path)
                if data != nil {
                    do {
                        let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        if let dictionary = object as? [String: AnyObject] {
                            readJSONObject(dictionary)
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                }
            }
        } else {
            var isDirectory: ObjCBool = false
            
            let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
            let jsonFilePath = documentsDirectoryPath.URLByAppendingPathComponent("menu.json")
            let fileManager = NSFileManager.defaultManager()
            
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
        }
        
    }

    func readJSONObject(object: [String: AnyObject]) {
        guard let menu = object["menu"] as? [[String: AnyObject]] else { return }
        
        for section in menu {
            let name = section["Section"] as? String
            
            let titles = section["Titles"] as? [[String: AnyObject]]
            var titlesArray = [String]()
            for title in titles! {
                titlesArray.append(title["Title"] as! String)
            }
            
            Utilities.dictionary.setValue(titlesArray, forKey: name!)
        }
    }
        
    func reloadData(){
        self.myTable.reloadData()
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
        
        let sectionName : String = Utilities.dictionary.allKeys[indexPath.section] as! String
        let cellTitle   : String = (Utilities.dictionary[sectionName] as! [String])[indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewControllerWithIdentifier("textViewerCVC") as! textViewerCVC
        
        controller.file = cellTitle
        controller.section = sectionName
        
        //controller.parentViewController = self
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName : String = Utilities.dictionary.allKeys[section] as! String
        return sectionName
    }
    

}

extension ViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Utilities.dictionary.allKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey : String = Utilities.dictionary.allKeys[section] as! String //
        let arrayForSection     = Utilities.dictionary[sectionKey] //White belt, etc...
        
        return arrayForSection!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customTVC
        
        let sectionKey : String = Utilities.dictionary.allKeys[indexPath.section] as! String
        let arrayForSection : [String]    = Utilities.dictionary[sectionKey] as! [String]

        cell.myImage.image = UIImage(named : "icon")
        cell.myTitle.text = arrayForSection[indexPath.row]
        cell.mySubtitle.text = ""
        cell.section = sectionKey
        cell.file = arrayForSection[indexPath.row]

        return cell
    }
    
    @IBAction func addNote(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewControllerWithIdentifier("textViewerCVC") as! textViewerCVC
        controller.operation = "Create"
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}