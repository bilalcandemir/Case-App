//
//  HomeViewController.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlets -
    @IBOutlet private weak var mainCollectionView: UICollectionView!

    // MARK: - Properties -
    private var lineSpacingForList = 8.0
    private var viewModel = HomeViewModel()
    private var rightBarButton: UIBarButtonItem?

    // MARK: - Functions -
    override func configureUI() {
        super.configureUI()
        self.showLoadingView()
        registerCollectionView()
        viewModel.sendPopularMovieRequest { [weak self] success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingView()
                    self?.mainCollectionView.reloadData()
                }
            } else {
                
            }
        }
        self.title = "Contents"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: viewModel.getImageName()), style: .plain, target: self, action: #selector(styleChangeButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        mainCollectionView.reloadData()
    }

    @objc private func styleChangeButtonAction() {
        viewModel.toggleStyle()
        rightBarButton?.image = UIImage(systemName: viewModel.getImageName())
        mainCollectionView.reloadData()
    }

    private func registerCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        [HomeGridCollectionCell.self, HomeListCollectionCell.self, LoadMoreCollectionCell.self].forEach({
            mainCollectionView.register(UINib(nibName: $0.identifier, bundle: nil), forCellWithReuseIdentifier: $0.identifier)
        })
    }
}

// MARK: - Collection View Delegation -
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getMovieCount() + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == viewModel.getMovieCount() {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCollectionCell.identifier, for: indexPath) as? LoadMoreCollectionCell else { return .init() }
            cell.delegate = self
            return cell
        }

        switch viewModel.viewControllerStyle {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeListCollectionCell.identifier, for: indexPath) as? HomeListCollectionCell else { return .init() }
            cell.configureCell(viewModel.getMovie(where: indexPath))
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGridCollectionCell.identifier, for: indexPath) as? HomeGridCollectionCell else { return .init() }
            cell.configureCell(viewModel.getMovie(where: indexPath))
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.getMovie(where: indexPath)
        Router.shared.navigate(DetailViewController(), animated: true, data: DetailViewControllerData.init(movieId: item?.id, movieTitle: item?.title), in: self.navigationController)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.viewControllerStyle {
        case .list:
            return CGSize(width: UIScreen.main.bounds.width - lineSpacingForList, height: 200)
        case .grid:
            return CGSize(width: (UIScreen.main.bounds.width / 2) - lineSpacingForList, height: 200)
        }
    }
}

extension HomeViewController: LoadMoreCollectionCellProtocol {
    func showMoreButtonPressed() {
        showLoadingView()
        viewModel.loadMoreButtonAction()
        viewModel.sendPopularMovieRequest { success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingView()
                    self?.mainCollectionView.reloadData()
                }
            }
        }
    }
}

struct DetailViewControllerData {
    let movieId: Int?
    let movieTitle: String?
}
