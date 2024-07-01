//
//  DetailViewController.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import UIKit

final class DetailViewController: BaseViewController {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    private var viewModel = DetailViewModel()
    private var rightBarButton: UIBarButtonItem?

    override func configureUI() {
        super.configureUI()
        getVCData()
        viewModel.getMovieDetail { [weak self] success in
            if success {
                UIImage.setImage(withURLString: self?.viewModel.getImagePath() ?? "") { image in
                    if let image {
                        DispatchQueue.main.async { [weak self] in
                            self?.movieImageView.image = image
                            self?.textView.text = self?.viewModel.getMovieOverview()
                        }
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let imageName = FavoriteMovieHolderManager.shared.hasFavorite(movieId: viewModel.vcData?.movieId ?? 0) ? UIImage.init(systemName: "star.fill") : UIImage.init(systemName: "star") else { return }
        rightBarButton = UIBarButtonItem(image: imageName, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc private func favoriteButtonTapped() {
        FavoriteMovieHolderManager.shared.saveMovie(movieId: viewModel.vcData?.movieId)
        if FavoriteMovieHolderManager.shared.hasFavorite(movieId: viewModel.vcData?.movieId ?? 0) {
            rightBarButton?.image = UIImage.init(systemName: "star.fill")
        } else {
            rightBarButton?.image = UIImage.init(systemName: "star")
        }
    }

    func getVCData() {
        if let sharedData = sharedData as? DetailViewControllerData {
            viewModel.vcData = sharedData
            self.title = sharedData.movieTitle
        }
    }
}
