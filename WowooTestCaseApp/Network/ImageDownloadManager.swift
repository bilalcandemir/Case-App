//
//  ImageDownloadManager.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation

final class ImageDownloadManager {
    static let shared = ImageDownloadManager()

    private var session = URLSession.shared
    private var cache: [URL: Data] = [:]

    func downloadData(withURL url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let cachedData = cache[url] {
            completion(.success(cachedData))
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), components.host != nil else {
            let customError = NSError(domain: "DataDownloadError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(customError))
            return
        }

        let task = session.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                let customError = NSError(domain: "DataDownloadError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "data download error: \(error.localizedDescription)"])
                completion(.failure(customError))
                return
            }

            guard let data = data else {
                let customError = NSError(domain: "DataDownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty data"])
                completion(.failure(customError))
                return
            }
            self?.cache[url] = data
            
            completion(.success(data))
        }
        task.resume()
    }
}
