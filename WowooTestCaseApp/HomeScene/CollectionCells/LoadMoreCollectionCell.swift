//
//  LoadMoreCollectionCell.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import UIKit

protocol LoadMoreCollectionCellProtocol: AnyObject {
    func showMoreButtonPressed()
}

final class LoadMoreCollectionCell: BaseCollectionCell {
    weak var delegate: LoadMoreCollectionCellProtocol?

    override func configureUI() {
        super.configureUI()
    }

    func configureCell(_ delegate: LoadMoreCollectionCellProtocol?) {
        self.delegate = delegate
    }

    @IBAction func loadMoreButton(_ sender: Any) {
        delegate?.showMoreButtonPressed()
    }
}
