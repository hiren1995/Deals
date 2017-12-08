//
//  postListCell.swift
//  Deals
//
//  Created by iosdeveloper on 08/11/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import PinterestLayout

class postListCell: UICollectionViewCell {
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var soldImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            //change image view height by changing its constraint
            // imageViewHeightLayoutConstraint.constant = attributes.imageHeight
            postImage.frame.size.height = attributes.imageHeight
            detailsView.frame.origin.y = postImage.frame.size.height + 10
            detailsView.frame.size.height = 50.0
        }
    }
}
