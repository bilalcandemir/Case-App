//
//  HomeGridCollectionCell.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import UIKit

final class HomeGridCollectionCell: BaseCollectionCell {

    @IBOutlet private weak var movieContentImage: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var movieTitleView: UIView!
    @IBOutlet private weak var favoriteIconImageView: UIImageView!

    private var movieId = 0
    
    override func configureUI() {
        super.configureUI()
        containerView.layer.cornerRadius = 12
        movieTitleView.roundCorners([.bottomRight, .bottomLeft], radius: 12)
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        FavoriteMovieHolderManager.shared.saveMovie(movieId: movieId)
        if FavoriteMovieHolderManager.shared.hasFavorite(movieId: movieId) {
            favoriteIconImageView.image = UIImage.init(systemName: "star.fill")
        } else {
            favoriteIconImageView.image = UIImage.init(systemName: "star")
        }
    }

    func configureCell(_ item: MovieContentModel?) {
        UIImage.setImage(withURLString: item?.posterPath?.convertImageUrlFormat()) { [weak self] image in
            if let image {
                DispatchQueue.main.async { [weak self] in
                    self?.movieContentImage.image = image
                }
            }
        }
        self.movieId = item?.id ?? 0
        favoriteIconImageView.image = FavoriteMovieHolderManager.shared.hasFavorite(movieId: movieId) ? UIImage.init(systemName: "star.fill") : UIImage.init(systemName: "star")
        movieNameLabel.text = item?.title
    }
}
