//
//  TableViewCell.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/15/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var crimeTypeLabel: UILabel!
    @IBOutlet weak var crimeDistance: UILabel!
    @IBOutlet weak var crimeDate:UILabel!
    @IBOutlet weak var crimeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
