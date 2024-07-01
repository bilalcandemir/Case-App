//
//  HomeListCollectionCell.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import UIKit

final class HomeListCollectionCell: BaseCollectionCell {
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieContentImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var movieTitleView: UIView!

    private var movieId = 0
    private var image: UIImage?

    override func configureUI() {
        super.configureUI()
        containerView.layer.cornerRadius = 12
        movieTitleView.roundCorners([.bottomRight, .bottomLeft], radius: 12)
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        FavoriteMovieHolderManager.shared.saveMovie(movieId: movieId)
        if FavoriteMovieHolderManager.shared.hasFavorite(movieId: movieId) {
            starImageView.image = UIImage.init(systemName: "star.fill")
        } else {
            starImageView.image = UIImage.init(systemName: "star")
        }

        let baseURL = "//www.nftcalculatorsapp.net"
        ImageUploader.uploadImage(session: URLSession.shared, image: image ?? .init(), endpoint: NetworkRouter.sendImage, baseURL: baseURL) { (result: Result<ImageUploadResponseModel, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }

    func configureCell(_ item: MovieContentModel?) {
        UIImage.setImage(withURLString: item?.posterPath?.convertImageUrlFormat()) { [weak self] image in
            if let image {
                DispatchQueue.main.async { [weak self] in
                    self?.movieContentImageView.image = image
                    self?.image = image
                }
            }
        }
        self.movieId = item?.id ?? 0
        starImageView.image = FavoriteMovieHolderManager.shared.hasFavorite(movieId: movieId) ? UIImage.init(systemName: "star.fill") : UIImage.init(systemName: "star")
        movieNameLabel.text = item?.title
    }
}
