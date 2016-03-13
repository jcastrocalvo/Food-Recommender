//
//  CardCellTableViewCell.swift
//  FoodRecommender
//
//  Created by Joaquin Castro-Calvo on 3/13/16.
//  Copyright © 2016 Joaquin Castro-Calvo. All rights reserved.
//

import UIKit

class CardCellTableViewCell: UITableViewCell {

    @IBOutlet var cellTitle: UILabel!

    @IBOutlet var cellDescription: UITextView!
    
    @IBOutlet var cellImage: UIImageView!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
