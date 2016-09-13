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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("menu", withExtension: "json")
        
        //This logic verify if the JSON menu exists.
        if url != nil {
            Utilities.readURLFile(url!)
        }else{
            Utilities.createJSONMenu()
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
        
        let sectionName : String = Utilities.self.dictionary.allKeys[indexPath.section] as! String
        let cellTitle   : String = (Utilities.self.dictionary[sectionName] as! [String])[indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : textViewerCVC = storyBoard.instantiateViewControllerWithIdentifier("textViewerCVC") as! textViewerCVC
        
        controller.file = cellTitle
        controller.section = sectionName
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName : String = Utilities.self.dictionary.allKeys[section] as! String
        return sectionName
    }
    

}

extension ViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Utilities.self.dictionary.allKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey : String = Utilities.self.dictionary.allKeys[section] as! String //
        let arrayForSection     = Utilities.self.dictionary[sectionKey] //White belt, etc...
        
        return arrayForSection!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customTVC
        
        let sectionKey : String = Utilities.self.dictionary.allKeys[indexPath.section] as! String
        let arrayForSection : [String]    = Utilities.self.dictionary[sectionKey] as! [String]

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