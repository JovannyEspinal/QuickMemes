//
//  ImageViewController.swift
//  BPT
//
//  Created by Jovanny Espinal on 11/25/16.
//  Copyright © 2016 Jovanny Espinal. All rights reserved.
//

import UIKit
import Social
import SDWebImage

class ImageViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareButtonTapped))
    }
    
    func shareButtonTapped() {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.add(image.image!)
            vc.add(URL(string: image.sd_imageURL().absoluteString))
            present(vc, animated: true)
        }
    } 
}
