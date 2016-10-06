//
//  Utilities.swift
//  First Class
//
//  Created by Miguel Beltran on 12/09/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import Foundation

class Utilities{
    
    static var dictionary : NSMutableDictionary = NSMutableDictionary()
    static var imagesDictionary : NSMutableDictionary = NSMutableDictionary()
    static var images = [AnyObject]()
    
    static func getFilePath(_ file : String) -> URL {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = URL(string: documentsDirectoryPathString)!
        
        let filePath = documentsDirectoryPath.appendingPathComponent(file)
        return filePath
    }
    
    
    //This Function is to create our JSONMenu
    static func createJSONMenu(_ jsonData: Data){
        let jsonFilePath = getFilePath("menu.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // creating a .json file in the Documents folder
        if fileManager.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory) {
            do {
                print("File already exists")
                let url = URL(fileURLWithPath: jsonFilePath.absoluteString)
                try fileManager.removeItem(at: url)
            } catch {
                print(error)
            }
        }
        
        let created = fileManager.createFile(atPath: jsonFilePath.absoluteString, contents: nil, attributes: nil)
        if created {
            print("File created ")
        } else {
            print("Couldn't create file for some reason")
        }
        
        // Write that JSON to the file created earlier
        //jsonFilePath = documentsDirectoryPath.URLByAppendingPathComponent("menu.json")
        do {
            let file = try FileHandle(forWritingTo: jsonFilePath)
            file.write(jsonData)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    
    //This Function is to read our URL with our JSONMenu
    static func readURLFile(_ url: AnyObject, Action: String){
        
        let data = try? Data(contentsOf: url as! URL)
        do {
            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(dictionary)
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        
        if(Action == "Edit"){
            
        }else if (Action == "Delete"){
            
        }
    }
    
    
    //This function reads a JSONObject
    static func readJSONObject(_ object: [String: AnyObject]) {
        guard let menu = object["menu"] as? [[String: AnyObject]] else { return }
        
        for section in menu {
            let name = section["Section"] as? String
            let titles = section["Titles"] as? [[String: AnyObject]]
            
            var titlesArray = [String]()
            
            for title in titles! {
                titlesArray.append(title["Title"] as! String)
            }
            
            self.dictionary.setValue(titlesArray, forKey: name!)
            
            var imagesArray : [[String: AnyObject]] = []
            let images = section["Images"] as? [[String: AnyObject]]
            for image in images! {
                let i : [String : String] = [
                    "Id" : image["Id"] as! String
                    ,"Image" : image["Image"] as! String
                ]
                imagesArray.append(i as [String : AnyObject])
            }
            
            self.imagesDictionary.setValue(imagesArray, forKey: name!)
        }
    }
    
    //Parse NSDictionary to JSON Object
    static func parseDictionary(_ dictionaryA: NSDictionary){
        var jsonData = Data()
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dictionaryA, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        
        createJSONMenu(jsonData)
        
    }
    
    static func createMenu(){
        var menu : [[String: AnyObject]] = []
        
        for section in self.dictionary.allKeys {
            
            var images : [[String: AnyObject]] = []
            let imagesArrayForSection : [AnyObject]    = self.imagesDictionary[section as! String] as! [AnyObject]
            
            for image in imagesArrayForSection {
                let i : [String : String] = [
                    "Id" : image["Id"] as! String
                    ,"Image" : image["Image"] as! String
                ]
                images.append(i as [String : AnyObject])
            }
            
            var titles : [[String: AnyObject]] = []
            let arrayForSection : [String]    = self.dictionary[section as! String] as! [String]
            
            for title in arrayForSection {
                let t : [String : AnyObject] = [
                    "Title" : title as AnyObject
                ]
                titles.append(t)
            }
            
            let s : [String : AnyObject] = [
                "Section" : section as! String as AnyObject
                ,"Titles" : titles as AnyObject
                ,"Images" : images as AnyObject
            ]
            
            menu.append(s)
        }
        
        let jsonObject: [String: AnyObject] = [
            "menu": menu as AnyObject
        ]
        
        // creating JSON out of the above array
        var jsonData: Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        createJSONMenu(jsonData)
    }
    
    static func readFile(_ file : String) -> String{
        //_ file : String) -> URL
        let pathForTheFile = getFilePathToRead(file)
        
        do{
            let contents = try NSString(contentsOfFile: pathForTheFile, encoding: String.Encoding.ascii.rawValue) as String
            return contents
        }catch{
            print(error)
        }
        return "Error"
    }
    
    static func getFilePathToRead(_ file : String) -> String {
        var plistPathInDocument:String = String()
        
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        
        plistPathInDocument = rootPath + ("/" + (file) + ".strings")
        
        return plistPathInDocument
        
    }
    
    
}
