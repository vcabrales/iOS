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
    static func createJSONMenu(jsonData: NSData){
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        var jsonFilePath = documentsDirectoryPath.URLByAppendingPathComponent("menu.json")
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
        
        // Write that JSON to the file created earlier
        jsonFilePath = documentsDirectoryPath.URLByAppendingPathComponent("menu.json")
        do {
            let file = try NSFileHandle(forWritingToURL: jsonFilePath)
            file.writeData(jsonData)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
        
        //readURLFile(jsonFilePath)
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
    
    
    //This function reads a JSONObject
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
            
            parseDictionary(self.dictionary)
        }
    }
    
    //Parse NSDictionary to JSON Object
    static func parseDictionary(dictionaryA: NSDictionary){
        var jsonData = NSData()
        
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(dictionaryA, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            print(jsonData)
        } catch let error as NSError {
            print(error)
        }
        
        createJSONMenu(jsonData)

    }
}