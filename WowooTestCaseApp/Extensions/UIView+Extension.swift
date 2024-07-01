//
//  UIView+Extension.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 1.07.2024.
//

import Foundation
import UIKit
protocol CustomLayer {
    func refreshLayer(frame: CGRect, corners: UIRectCorner, cornerRadius: CGFloat)
}
extension UIView {
    static private var viewCustomLayersKey = "UIView.CustomLayers"
    var customLayers: [CustomLayer] {
        get {
            if objc_getAssociatedObject(self, &UIView.viewCustomLayersKey) as? [CustomLayer] == nil {
                self.customLayers = [CustomLayer]()
            }
            return objc_getAssociatedObject(self, &UIView.viewCustomLayersKey) as? [CustomLayer] ?? []
        }
        set {
            let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &UIView.viewCustomLayersKey, newValue, nonatomic)
        }
    }
    func refreshCustomLayers(frame: CGRect) {
        for customLayer in self.customLayers {
            customLayer.refreshLayer(frame: frame, corners: self.roundedCorners ?? .allCorners,
                                     cornerRadius: self.roundedCornerRadius ?? 0)
        }
    }
    static private var viewIsLayerObserverAddedKey = "UIView.IsLayerObserverAdded"
    var isLayerObserverAdded: Bool {
        get {
            return objc_getAssociatedObject(self, &UIView.viewIsLayerObserverAddedKey) as? Bool ?? false
        }
        set {
            let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
            objc_setAssociatedObject(self, &UIView.viewIsLayerObserverAddedKey, newValue, nonatomic)
        }
    }
    static private var viewRoundedCornersKey = "UIView.RoundedCorners"
    var roundedCorners: UIRectCorner? {
        get {
            return objc_getAssociatedObject(self, &UIView.viewRoundedCornersKey) as? UIRectCorner
        }
        set {
            let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &UIView.viewRoundedCornersKey, newValue, nonatomic)
        }
    }
    static private var viewRoundedCornerRadiusKey = "UIView.RoundedCornerRadius"
    var roundedCornerRadius: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &UIView.viewRoundedCornerRadiusKey) as? CGFloat
        }
        set {
            let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC
            objc_setAssociatedObject(self, &UIView.viewRoundedCornerRadiusKey, newValue, nonatomic)
        }
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
