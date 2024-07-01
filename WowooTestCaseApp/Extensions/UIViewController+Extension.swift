//
//  UIViewController+Extension.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation
import UIKit

extension UIViewController {

    func showLoadingView() {
        let loadingView = LoadingView(frame: self.view.bounds)
        loadingView.tag = 999
        self.view.addSubview(loadingView)
    }

    func hideLoadingView() {
        if let loadingView = self.view.viewWithTag(999) {
            loadingView.removeFromSuperview()
        }
    }
    var sharedData: DGSharedData? {
        get {
            return objc_getAssociatedObject(self, &sharedDataAssociationKey) as DGSharedData?
        }
        set(newValue) {
            objc_setAssociatedObject(self, &sharedDataAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
