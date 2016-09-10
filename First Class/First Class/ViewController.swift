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
    
    var dictionary : NSDictionary = [
        "White Belt"   : ["Conceptos basicos", "Conceptos basicos II", "Frank no vino", "Navegacion basica"]
        //,"Section 2"  : ["Title_1","Title_2"]
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSBundle.mainBundle().URLForResource("menu", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(dictionary)
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }

    func readJSONObject(object: [String: AnyObject]) {
        guard let menu = object["menu"] as? [[String: AnyObject]] else { return }
        
        
        for section in menu {
            let name = section["Section"] as? String
            print(name)
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
        
        print("Seleccione celda \(indexPath.row) en la seccion \(cellTitle) ")
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewControllerWithIdentifier("textViewerCVC") as! textViewerCVC
        
        controller.titleString = cellTitle
      
        if let filepath = NSBundle.mainBundle().pathForResource(cellTitle, ofType: "strings") {
             do {
                let contents = try NSString(contentsOfFile: filepath, encoding: NSASCIIStringEncoding) as String
                controller.textString = contents
                print(contents)
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("\(cellTitle) not found!")
        }

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

}