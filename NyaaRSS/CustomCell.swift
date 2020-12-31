//
//  CustomCell.swift
//  NyaaRSS
//
//  Created by Hervé PIERRE on 26/12/2020.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var titre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
