//
//  ViewController.swift
//  First Class
//
//  Created by Victor Cabrales on 8/26/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit
import CoreText

class ViewController: UIViewController{

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var myScrollview: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myScrollview.contentSize.height = 1000
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
        {
            let path = URL(fileURLWithPath: dir).appendingPathComponent("menu.json")
            
            //reading
            do {
                
                let data = try? Data(contentsOf: path)
                if data != nil {
                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let dictionary = object as? [String: AnyObject] {
                            readJSONObject(dictionary)
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                }else {
                    let jsonFilePath = Utilities.getFilePath("menu.json")
                    let fileManager = FileManager.default
                    
                    // creating a .json file in the Documents folder
                    var isDirectory: ObjCBool = false
                    if !fileManager.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory) {
                        let created = fileManager.createFile(atPath: jsonFilePath.absoluteString, contents: nil, attributes: nil)
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
        }
    }

    func readJSONObject(_ object: [String: AnyObject]) {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionName : String = Utilities.dictionary.allKeys[(indexPath as NSIndexPath).section] as! String
        let cellTitle   : String = (Utilities.dictionary[sectionName] as! [String])[(indexPath as NSIndexPath).row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewController(withIdentifier: "textViewerCVC") as! textViewerCVC
        
        controller.file = cellTitle
        controller.section = sectionName
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Utilities.dictionary.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey : String = Utilities.dictionary.allKeys[section] as! String
        let arrayForSection     = Utilities.dictionary[sectionKey]
        
        return (arrayForSection! as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTVC
        
        let sectionKey : String = Utilities.dictionary.allKeys[(indexPath as NSIndexPath).section] as! String
        let arrayForSection : [String]    = Utilities.dictionary[sectionKey] as! [String]

        cell.myImage.image = UIImage(named : "icon")
        cell.myTitle.text = arrayForSection[(indexPath as NSIndexPath).row]
        
        cell.myContent.text = Utilities.readFile(arrayForSection[(indexPath as NSIndexPath).row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName : String = Utilities.dictionary.allKeys[section] as! String
        return sectionName
    }
    
    private func tableView(ableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let myQuestion = UIAlertController(title: "Delete", message: "Are you sure you want to permanently delete this file?", preferredStyle: UIAlertControllerStyle.alert)
            
                myQuestion.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction!) in
                    // handle delete (by removing the data from your array and updating the tableview)
                    let sectionKey : String = Utilities.dictionary.allKeys[(indexPath as NSIndexPath).section] as! String
                    let arrayForSection : [String]    = Utilities.dictionary[sectionKey] as! [String]
                
                    let filePath = Utilities.getFilePath("\(arrayForSection[(indexPath as NSIndexPath).row]).strings")
                    let fileManager = FileManager.default
                
                    // creating a .string file in the Documents folder
                    var isDirectory: ObjCBool = false
                    if fileManager.fileExists(atPath: filePath.absoluteString, isDirectory: &isDirectory)
                    {
                        let url = URL(fileURLWithPath: filePath.absoluteString)
                        do {
                            try fileManager.removeItem(at: url)
                        
                            var titlesArray : [String]
                            titlesArray = [String]()
                        
                            if arrayForSection.count == 1 {
                                Utilities.dictionary.removeObject(forKey: sectionKey)
                            } else {
                                for title in arrayForSection {
                                    if title != arrayForSection[(indexPath as NSIndexPath).row] {
                                        titlesArray.append(title)
                                    }
                                }
                                Utilities.dictionary.setValue(titlesArray, forKey: sectionKey)
                            }
                        
                            Utilities.createMenu()
                            tableView.beginUpdates()
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            if arrayForSection.count == 1 {
                                // Delete section if no more rows
                                let indexSet = NSMutableIndexSet()
                                indexSet.add(indexPath.section)
                                tableView.deleteSections(indexSet as IndexSet, with: .fade)
                            }
                            tableView.endUpdates()
                        } catch {
                            print(error)
                        }
                    }
            }))
            
            myQuestion.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
                //self.myTable.reloadData()
            }))
            
            present(myQuestion, animated: true, completion: nil)
        }
    }

    
    @IBAction func addNote(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewController(withIdentifier: "textViewerCVC") as! textViewerCVC
        controller.operation = "Create"
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
}

extension ViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
