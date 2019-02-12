//
//  ListTableViewCell.swift
//  Pokedex
//
//  Created by Thobio on 08/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import Skeleton


class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViews:UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
