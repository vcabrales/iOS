//
//  textViewerCVC.swift
//  First Class
//
//  Created by Victor Cabrales on 9/1/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class textViewerCVC: UIViewController {

    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myContent: UITextView!
 
    var titleString : String?
    var textString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTitle.text = titleString
        myContent.text = textString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
