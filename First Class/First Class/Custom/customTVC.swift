//
//  customTVC.swift
//  First Class
//
//  Created by Victor Cabrales on 8/27/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class customTVC: UITableViewCell {

    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var mySubtitle: UILabel!
    
    @IBAction func Delete(sender: AnyObject) {
        let File = "/" + myTitle.text! + ".strings"
        var path = "/Users/user/Desktop/Swift/iOS/iOS/First Class/First Class"
        path.appendContentsOf(File)
        
        
        //if let filepath = NSBundle.mainBundle().pathForResource(File, ofType: "strings") {
            //print(filepath)
            do {
                let fileManager = NSFileManager.defaultManager()
                try fileManager.removeItemAtPath(path)
            }
                catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        //} else {
        //    print("\(File) not found!")
        //}
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
