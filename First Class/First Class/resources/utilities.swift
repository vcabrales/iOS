//
//  utilities.swift
//  First Class
//
//  Created by Miguel Beltran on 12/09/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import Foundation

class Utilities{
    
    static var dictionary : NSMutableDictionary = [:]
    
    //This Function is to create our JSONMenu
    static func createJSONMenu(){
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
        
        
        let jsonObject: [String: AnyObject] =
            ["menu": [
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
    
    //This Function is to read our URL with our JSONMenu
    static func readURLFile(url: AnyObject){
        
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
    
    static func readJSONObject(object: [String: AnyObject]) {
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
}