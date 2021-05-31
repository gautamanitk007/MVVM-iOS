//
//  UserCell.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 31/5/21.
//

import UIKit

class UserCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    func configure(_ user:User){
        self.lblName.text = user.name
        self.lblCity.text = user.address?.city
        self.lblStreet.text = user.address?.street
    }
}
