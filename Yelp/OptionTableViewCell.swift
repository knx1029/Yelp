//
//  OptionTableViewCell.swift
//  Yelp
//
//  Created by Nanxi Kang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

enum OptionType {
    case OfferDeal
    case Category(index: Int)
}

protocol OptionTableViewCellDelegate: class {
    func switchTapped(_ cell: OptionTableViewCell)
}

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var optionLabel: UILabel!
    
    var optionType: OptionType = .OfferDeal
    
    weak var delegate: OptionTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchTapped(_ sender: Any) {
        delegate?.switchTapped(self)
    }
}
