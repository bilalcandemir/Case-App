//
//  ImageUploadResponseModel.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation

struct ImageUploadResponseModel: Decodable {
    let result: Bool?
    let responseMessage: String?
    let data: ImageUploadDataModel?
}

struct ImageUploadDataModel: Decodable {
    let base64str: String?
    let title: String?
}
