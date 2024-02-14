//
//  ImageCache.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/06.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    private var cache = NSCache<NSString, UIImage>()
    @Published var image: UIImage?
    
    func loadImage(from urlString: String) {
        if let cachedImage = cache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.image = nil
                }
                return
            }
            
            self?.cache.setObject(image, forKey: NSString(string: urlString))
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}



