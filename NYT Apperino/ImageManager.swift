//
//  ImageManager.swift
//  NYT Apperino
//
//  Created by William Choi on 8/13/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import UIKit

final class ImageManager{
    
    static let shared = ImageManager()
    
    private var images: [URL: UIImage] = [:]
    
    func image(url: URL, completion: ((UIImage, URL) -> Void)?){
        if let cachedImage = images[url]{
            DispatchQueue.main.async {
                completion?(cachedImage, url)    
            }
            
        }else{
            images[url] = nil
            
            //Download image
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){ data, response, error in
                guard error == nil else{ assertionFailure("Error while getting data in ImageManager.image"); return }
                guard let dlImage = UIImage(data: data!) else { assertionFailure("Could not UIImage(data) in ImageManager.image"); return }
                
                self.images[url] = dlImage
                DispatchQueue.main.async {
                    completion?(dlImage, url)
                }
                
            }.resume()
        }
    }
    
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(flushPictures), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    @objc func flushPictures(){
        images = [:]
    }
}
