//
//  FavoriteMovieHolderManager.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation

final class FavoriteMovieHolderManager {
    static let shared = FavoriteMovieHolderManager()

    private let userDefaultsKey = "favoriteMovies"
    private var favoriteMovieList: [Int] {
        get {
            return UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
        }
    }

    private init() {
        favoriteMovieList = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] ?? []
    }

    func hasFavorite(movieId: Int) -> Bool {
        return favoriteMovieList.contains(movieId)
    }

    func saveMovie(movieId: Int?) {
        guard let movieId = movieId else { return }
        if favoriteMovieList.contains(movieId) {
            if let index = favoriteMovieList.firstIndex(of: movieId) {
                favoriteMovieList.remove(at: index)
            }
        } else {
            favoriteMovieList.append(movieId)
        }
    }

    func getFavoriteMovies() -> [Int] {
        return favoriteMovieList
    }
}
