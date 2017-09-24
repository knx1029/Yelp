//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Nanxi Kang on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import AFNetworking
import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func setContent(business: Business) {
        businessImage.setImageWith(business.imageURL!)
        ratingImage.setImageWith(business.ratingImageURL!)
        nameLabel.text = business.name!
        distanceLabel.text = business.distance!
        reviewLabel.text = "\(business.reviewCount!) reviews"
        addressLabel.text = business.address!
        typeLabel.text = business.categories!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
