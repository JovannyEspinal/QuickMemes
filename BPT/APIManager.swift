//
//  APIManager.swift
//  BPT
//
//  Created by Jovanny Espinal on 11/25/16.
//  Copyright © 2016 Jovanny Espinal. All rights reserved.
//

import Foundation

enum Category: String {
    case top = "top/.json"
    case new = "new/.json"
    case popular = ".json"
}

class APIManager {
    static let manager = APIManager()
    private init() { }
    
    class func getMemes(from endpoint: String,
                        with category: Category,
                        callback: @escaping ([Meme]?) -> Void) {
        var endpoint = endpoint
        
        endpoint += category.rawValue
        
        guard let validEndpoint = URL(string: endpoint) else { return }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: validEndpoint) { (data, response, error) in
        
            if error != nil {
                print(error.debugDescription)
            }
            
            guard let memeData = data else { return }
            
            let allMemes = APIManager.manager.getMemes(with: memeData)
            
            callback(allMemes)
        }.resume()
        
    }
    
    func getMemes(with data: Data) -> [Meme]? {
        var allMemes = [Meme]()
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let json = jsonData as? [String:Any],
                let memeData = json["data"] as? [String:Any],
                let memes = memeData["children"] as? [[String: Any]] else { return nil }
        
            for meme in memes {
                if let memeObject = Meme(with: meme) {
                    allMemes.append(memeObject)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return allMemes
    }
}
