//
//  MainTableViewCell.swift
//  Launch
//
//  Created by MaxCheng on 2017/8/11.
//  Copyright © 2017年 com.USSwiftCoda. All rights reserved.
//

import UIKit

class QATableViewCell: UITableViewCell {

 
  @IBOutlet weak var lblLid: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
 
  @IBOutlet weak var lblResponse: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
