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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
