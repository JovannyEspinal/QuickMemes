//
//  Meme.swift
//  BPT
//
//  Created by Jovanny Espinal on 11/25/16.
//  Copyright © 2016 Jovanny Espinal. All rights reserved.
//

import Foundation

class Meme {
    let imageURL: URL
    let thumbnailURL: URL
    let domain: String
    let author: String
    let title: String
    
    init(imageURL: URL, thumbnailURL: URL, domain: String, author: String, title: String) {
        self.imageURL = imageURL
        self.thumbnailURL = thumbnailURL
        self.domain = domain
        self.author = author
        self.title = title
    }
    
    convenience init?(with dict: [String:Any]) {
        guard let data = dict["data"] as? [String: Any],
            let domain = data["domain"] as? String,
            let author = data["author"] as? String,
            let preview = data["preview"] as? [String: Any],
            let title = data["title"] as? String,
            let thumbnailString = data["thumbnail"] as? String,
            let thumbnailURL = URL(string: thumbnailString),
            let images = preview["images"] as? [[String: Any]],
            let imageObject = images.first,
            let imageData = imageObject["source"] as? [String: Any],
            let imageString = imageData["url"] as? String,
            let imageURL = URL(string: imageString) else { return nil }
        
        self.init(imageURL: imageURL,
                  thumbnailURL: thumbnailURL,
                  domain: domain,
                  author: author,
                  title: title)
    }
}
