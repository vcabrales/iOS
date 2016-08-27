//
//  ViewController.swift
//  First Class
//
//  Created by Victor Cabrales on 8/26/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTable: UITableView!
    
    var titles = ["Title1", "Title2", "Title3"]
    var subtitles = ["Subtitle1", "Subtitle2", "Subtitle3"]
    var images = [UIImage(named: "icon"), UIImage(named: "icon"), UIImage(named: "icon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customTVC
        
        cell.myImage.image = images[indexPath.row]
        cell.myTitle.text = titles[indexPath.row]
        cell.mySubtitle.text = subtitles[indexPath.row]
        
        return cell
    }
}

