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
    
    var section : String?
    var file :String?
    
    @IBAction func Delete(sender: AnyObject) {
        var isDirectory: ObjCBool = false
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        let FilePath = documentsDirectoryPath.URLByAppendingPathComponent("\(myTitle.text!).strings")
        let fileManager = NSFileManager.defaultManager()
        
        // creating a .string file in the Documents folder
        if fileManager.fileExistsAtPath(FilePath.absoluteString, isDirectory: &isDirectory) {
            let url = NSURL(fileURLWithPath: FilePath.absoluteString)
            do {
             try fileManager.removeItemAtURL(url)
                
                var titlesArray : [String]
                titlesArray = [String]()
                
                let oldTitlesArray = Utilities.dictionary[section!] as! [String]
                
                if oldTitlesArray.count == 1 {
                    Utilities.dictionary.removeObjectForKey(section!)
                } else {
                    for title in oldTitlesArray {
                        if title != myTitle.text {
                            titlesArray.append(title)
                        }
                    }
                    Utilities.dictionary.setValue(titlesArray, forKey: section!)
                }
                
                print(Utilities.dictionary)
                Utilities.createMenu()
                delegate?.updateTableView()
            } catch {
                print(error)
            }
        }
        
        
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
