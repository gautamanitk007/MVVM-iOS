//
//  GeneralCell.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 30/5/21.
//

import UIKit

class GeneralCell: UITableViewCell {
    @IBOutlet weak var lblCountry: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ vm:CountryViewModel){
        self.lblCountry.text = vm.countryName
        
    }
}
