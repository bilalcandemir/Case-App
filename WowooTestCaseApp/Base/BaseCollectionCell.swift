//
//  BaseCollectionCell.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configureUI() {
        
    }

    static var identifier: String {
        String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
