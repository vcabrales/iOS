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
        0   : ["Title":"Title_1","Subtitle":"Subtitle_1","Image":"icon"]
        ,1  : ["Title":"Title_2","Subtitle":"Subtitle_2","Image":"icon"]
        ,2  : ["Title":"Title_3","Subtitle":"Subtitle_3","Image":"icon"]
        ,3  : ["Title":"Title_4","Subtitle":"Subtitle_4","Image":"icon"]
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    }

extension ViewController : UITableViewDelegate {
    
}

extension ViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.allKeys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customTVC
        
        let dicto = dictionary[indexPath.row] as! NSDictionary
        
        cell.myImage.image = UIImage(named: dicto["Image"] as! String)
        cell.myTitle.text = (dicto["Title"] as! String)
        cell.mySubtitle.text = (dicto["Subtitle"] as! String)
        
        
        /*
         cell.myImage.image = images[indexPath.row]
         cell.myTitle.text = titles[indexPath.row]
         cell.mySubtitle.text = subtitles[indexPath.row]
         */
        return cell
    }

}