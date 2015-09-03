//
//  ReviewTableViewCell.swift
//  Rapido
//
//  Created by Alexander Hernandez on 9/2/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
  
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var summaryText: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
    ratingView.userInteractionEnabled = false
    summaryText.editable = false
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
