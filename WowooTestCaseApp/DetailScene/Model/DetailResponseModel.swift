//
//  DetailResponseModel.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import Foundation

struct DetailResponseModel: Codable {
    let adult: Bool?
    let belongsToCollection: BelongsToCollection?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case belongsToCollection = "belongs_to_collection"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case revenue
        case runtime
        case status
        case tagline
        case title
    }
}

struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

