//
//  HomeViewModel.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import Foundation

enum HomeViewStyle {
    case list, grid
}

final class HomeViewModel: BaseViewModel {
    private var popularMovieResponse: [MovieContentModel] = []
    var pageNumber = 1
    var viewControllerStyleDidChange: ((HomeViewStyle) -> Void)?

    var viewControllerStyle: HomeViewStyle = .list {
        didSet {
            viewControllerStyleDidChange?(viewControllerStyle)
        }
    }

    func toggleStyle() {
        viewControllerStyle = (viewControllerStyle == .list) ? .grid : .list
    }

    func getImageName() -> String {
        viewControllerStyle == .grid ? "list.bullet" : "rectangle.grid.2x2.fill"
    }

    func getMovieCount() -> Int {
        popularMovieResponse.count
    }

    func getMovie(where index: IndexPath) -> MovieContentModel? {
        popularMovieResponse[index.item]
    }

    func loadMoreButtonAction() {
        pageNumber += 1
    }

    func sendPopularMovieRequest(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.requestData(from: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=\(pageNumber)", responseType: MovieResponseModel.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.popularMovieResponse.append(contentsOf: success.movies ?? [])
                completion(true)
            case .failure(let failure):
                completion(false)
            }
        }
    }
}
