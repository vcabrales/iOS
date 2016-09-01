//
//  ViewController.swift
//  Simple Calculator
//
//  Created by Victor Cabrales on 8/30/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel : UILabel!
    var currentOp : String = ""
    var result    : Float = 0.0
    var currentNum: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentOp = "="
        self.myLabel.text = ("\(result)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(sender: UIButton) {
        result = 0
        currentNum = 0
        currentOp = "="
        self.myLabel.text = ("\(result)")
    }

    @IBAction func operation(sender: UIButton) {
        if(currentOp == "="){
            result = currentNum
        } else if(currentOp == "*"){
            result = result * currentNum
        } else if(currentOp == "/"){
            result = result / currentNum
        } else if(currentOp == "+"){
            result = result + currentNum
        } else if(currentOp == "-"){
            result = result - currentNum
        }
        
        currentNum = 0
        self.myLabel.text = ("\(result)")
        if(sender.titleLabel!.text == "="){
            result = 0
        }
        currentOp = sender.titleLabel!.text! as String
    }

    @IBAction func numberInput(sender: UIButton) {
        currentNum = currentNum * 10 + Float(sender.titleLabel!.text!)!
        self.myLabel.text = ("\(currentNum)")
    }
}

