//
//  MyTableViewCell.swift
//  MarvelApp
//
//  Created by Wojciech Spaleniak on 28/06/2022.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var myBackgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let marginLR = 15.0
        let marginTB = 7.5
        
        
        let widthBg = Double(myBackgroundImage.bounds.size.width)
        let heightBg = Double(myBackgroundImage.bounds.size.height)
        
        myBackgroundImage.layer.cornerRadius = 15.0
        thumbnailImageView.layer.cornerRadius = 15.0

        thumbnailImageView.frame = CGRect(x: marginLR, y: marginTB, width: widthBg / 3 + 15, height: heightBg + 5)
        
        let widthImg = Double(thumbnailImageView.frame.size.width)
        
        titleLabel.frame = CGRect(x: marginLR + widthImg + 10, y: marginTB + 10, width: 160, height: 25)
        creatorLabel.frame = CGRect(x: marginLR + widthImg + 10, y: marginTB + 10 + 25, width: 160, height: 15)
        descriptionLabel.frame = CGRect(x: marginLR + widthImg + 10, y: marginTB + 10 + 25 + 20, width: widthBg - 70, height: 100)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
