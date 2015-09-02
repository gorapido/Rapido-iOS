//
//  XLFormRatingCell.swift
//  Rapido
//
//  Created by Alexander Hernandez on 9/2/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import XLForm
import Cosmos

let XLFormRowDescriptorTypeRate = "XLFormRowDescriptorTypeRate"

class XLFormRatingCell: XLFormBaseCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  
  override func configure() {
    super.configure()
    
    selectionStyle = .None
  }
  
  override func update() {
    super.update()
    
    titleLabel.text = rowDescriptor.title
    ratingView.rating = rowDescriptor.value!.doubleValue
  }

}
