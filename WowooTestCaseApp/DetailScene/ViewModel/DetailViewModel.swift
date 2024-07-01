//
//  DetailViewModel.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import Foundation

final class DetailViewModel: BaseViewModel {
    private var responseData: DetailResponseModel?
    var vcData: DetailViewControllerData?

    func getMovieDetail(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.requestData(from: "https://api.themoviedb.org/3/movie/\(vcData?.movieId ?? 0)", responseType: DetailResponseModel.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.responseData = success
                completion(true)
            case .failure(let failure):
                completion(false)
            }
        }
    }

    func getMovieOverview() -> String {
        responseData?.overview ?? ""
    }

    func getImagePath() -> String? {
        responseData?.posterPath?.convertImageUrlFormat()
    }
}
