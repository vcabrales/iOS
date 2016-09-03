//
//  ViewController.swift
//  First Class
//
//  Created by Victor Cabrales on 8/26/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    
    var titles = ["Title1", "Title2", "Title3"]
    var subtitles = ["Subtitle1", "Subtitle2", "Subtitle3"]
    var images = [UIImage(named: "icon"), UIImage(named: "icon"), UIImage(named: "icon")]
    
 
    var dictionary : NSDictionary = [
        "White Belt"   : ["Conceptos basicos", "Conceptos basicos II", "Frank no vino", "Navegacion basica"]
        //,"Section 2"  : ["Title_1","Title_2"]
    ]
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.myTable.delegate = self
        //self.myTable.dataSource = self
        
        
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
        let sectionKey : String = self.dictionary.allKeys[section] as! String
        let arrayForSection     = self.dictionary[sectionKey]
        
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