//
//  MemeCell.swift
//  BPT
//
//  Created by Jovanny Espinal on 11/25/16.
//  Copyright © 2016 Jovanny Espinal. All rights reserved.
//

import UIKit
import SDWebImage

class MemeCell: UITableViewCell {
    
    @IBOutlet weak var memeThumbnail: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with meme: Meme) {
        self.captionLabel.text = meme.title
        self.domainLabel.text = meme.domain
        self.authorLabel.text = meme.author
        
        self.memeThumbnail.sd_setImage(with: meme.thumbnailURL,
                                       placeholderImage: UIImage(named: "noImageAvailable"))
    }
    
    
    
}
