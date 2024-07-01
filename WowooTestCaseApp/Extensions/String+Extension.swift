//
//  String+Extension.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation

extension String {
    func convertImageUrlFormat() -> String {
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        return baseUrl + self
    }
}
