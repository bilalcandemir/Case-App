//
//  LoadingView.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation
import UIKit

final class LoadingView: UIView {

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.clipsToBounds = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.color = .orange
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadingLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
