//
//  BaseNavigationController.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavigationBarAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationBarAppearance()
    }

    private func setupNavigationBarAppearance() {
        navigationBar.tintColor = .white
    }
}
