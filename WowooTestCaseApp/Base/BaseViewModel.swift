//
//  BaseViewModel.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import Foundation

var sharedDataAssociationKey: UInt8 = 0
typealias DGSharedData = Any

class BaseViewModel {

}

extension BaseViewModel {
    var sharedData: DGSharedData? {
        get {
            return objc_getAssociatedObject(self, &sharedDataAssociationKey) as DGSharedData?
        }
        set(newValue) {
            objc_setAssociatedObject(self, &sharedDataAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
