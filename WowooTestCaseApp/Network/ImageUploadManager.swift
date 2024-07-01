//
//  ImageUploadManager.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation
import UIKit
protocol Endpoint {
    var scheme: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}
enum NetworkRouter: Endpoint {
    case sendImage

    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }

        var scheme: String {
            switch self {
            default:
                return "https"
            }
        }

        var path: String {
            switch self {
            case .sendImage:
                return "/text_to_image_case_study"
            }
        }

        var parameters: [URLQueryItem] {
            switch self {
            default:
                return []
            }
        }
}

class ImageUploader {
    class func uploadImage<T: Decodable>(session: URLSession,
                                         image: UIImage,
                                         endpoint: Endpoint,
                                         baseURL: String,
                                         completion: @escaping (Swift.Result<T, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = endpoint.scheme

        if let baseURL = URL(string: baseURL) {
            components.host = baseURL.host

            let basePath = baseURL.path
            let combinedPath = basePath + endpoint.path
            components.path = combinedPath
            if !endpoint.parameters.isEmpty {
                components.queryItems = endpoint.parameters
            }

            guard let url = components.url else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endpoint.method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            guard let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 600, height: 600)) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to resize image."])))
                return
            }

            guard let base64ImageString = convertImageToBase64(image: resizedImage) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Base64."])))
                return
            }

            // JSON body oluştur
            let jsonBody: [String: Any] = [
                "prompt": "star name",
                "base64str": base64ImageString,
                "inputImage": false
            ]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create JSON body."])))
                return
            }

            let datatask = session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else {
                    completion(.failure(error ?? NSError()))
                    return
                }

                guard error == nil else {
                    completion(.failure(error ?? NSError()))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(error ?? NSError()))
                    return
                }

                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        do {
                            let responseObject = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(responseObject))
                        } catch {
                            let decodingError = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response: \(error.localizedDescription)"])
                            completion(.failure(decodingError))
                        }
                    default:
                        completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])))
                    }
                }
            }
            datatask.resume()
        }
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = CGSize(width: size.width * max(widthRatio, heightRatio),
                         height: size.height * max(widthRatio, heightRatio))
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: newSize))

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

func convertImageToBase64(image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
    return imageData.base64EncodedString(options: .lineLength64Characters)
}
