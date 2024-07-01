//
//  UIImage+Extension.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation
import MobileCoreServices
import UIKit

extension UIImage {
    private static var imageCache = NSCache<NSString, UIImage>()

    static func setImage(withURLString urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        if let cachedImage = UIImage.imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        ImageDownloadManager.shared.downloadData(withURL: url) { result in
            switch result {
            case let .success(data):
                if let image = UIImage(data: data) {
                    UIImage.imageCache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                completion(nil)
            }
        }
    }

    func applyOpacity(_ opacity: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect, blendMode: .normal, alpha: opacity)
        let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return modifiedImage
    }

    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

