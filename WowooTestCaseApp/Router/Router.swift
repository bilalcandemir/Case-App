//
//  Router.swift
//  WowooTestCaseApp
//
//  Created by Ahmet Bilal Candemir on 30.06.2024.
//

import Foundation
import UIKit

class Router: NSObject {
    static let shared = Router()
}

extension Router {
    func openAsRoot(viewC: UIViewController, isHidden: Bool? = false) {
        let navVC = UINavigationController.init(rootViewController: viewC)
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        navVC.navigationBar.isHidden = isHidden ?? false
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }

    func push(viewC: UIViewController, fromViewController: UIViewController? = nil,
              animated: Bool = true, shouldPopToRoot: Bool = false, isHidden: Bool? = false) {
        guard let navigationController =
                fromViewController?.navigationController ?? self.getCurrentNavigationController() else {
            return }
        navigationController.navigationBar.isHidden = isHidden ?? false
        if shouldPopToRoot {
            navigationController.popToRootViewController(animated: false)
        }
        navigationController.pushViewController(viewC, animated: animated)
    }

    func present(viewC: UIViewController, fromViewController: UIViewController? = nil,
                 animated: Bool = true, completion: PresentCompletion? = nil,
                 isWithNavigationController: Bool = false) {
        guard let navigationController =
                fromViewController?.navigationController ?? self.getCurrentNavigationController() else {
            return }
        if isWithNavigationController {
            let newC = UINavigationController.init(rootViewController: viewC)
            newC.modalPresentationStyle = .fullScreen
            navigationController.present(newC, animated: animated, completion: completion)
        } else {
            navigationController.present(viewC, animated: animated, completion: completion)
        }
    }

    typealias PresentCompletion = (() -> Void)

    func getCurrentNavigationController() -> UINavigationController? {
        guard let topViewController = UIApplication.topViewController() else { return nil }
        if let navigationController = topViewController.navigationController {
            return navigationController
        }
        return nil
    }
}

extension Router {
    func requestNavigation(_ controllerKey: UIViewController,
                           data: Any? = nil,
                           animated: Bool = true) {
        navigate(controllerKey, animated: animated, data: data)
    }

    func requestPresent(_ controllerKey: UIViewController,
                        data: Any? = nil,
                        animated: Bool = true,
                        modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        present(controllerKey, data: data, animated: animated, modalPresentationStyle: modalPresentationStyle)
    }

    func requestPresentWithNavigation(_ controllerKey: UIViewController,
                                      data: Any? = nil,
                                      animated: Bool = true,
                                      modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        present(controllerKey, data: data, animated: animated, modalPresentationStyle: modalPresentationStyle, withNavigation: true)
    }

    func popViewController(animated: Bool = true) {
        if let topViewController = UIApplication.topViewController(),
           let navigationController = topViewController.navigationController {
            navigationController.popViewController(animated: animated)
        }
    }

    func popToRootViewController(animated: Bool = true) {
        if let topViewController = UIApplication.topViewController(),
           let navigationController = topViewController.navigationController {
            navigationController.popToRootViewController(animated: animated)
        }
    }

    func dismiss(animated: Bool = true) {
        if let topViewController = UIApplication.topViewController() {
            topViewController.dismiss(animated: animated)
        }
    }

    func navigate(_ controllerKey: UIViewController,
                          animated: Bool,
                          data: Any?,
                          in navigationController: UINavigationController? = nil,
                          shouldHeroActive: Bool = true) {
        let topViewController = UIApplication.topViewController()
        controllerKey.sharedData = data
        navigationController?.pushViewController(controllerKey, animated: true)
    }

    private func present(_ controllerKey: UIViewController,
                         data: Any? = nil,
                         animated: Bool = true,
                         modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                         withNavigation: Bool = false) {
        let topViewController = UIApplication.topViewController()
        if animated {
            let containerView = topViewController?.view.window
            containerView?.backgroundColor = UIColor.clear
            containerView?.layer.add(transition(), forKey: nil)
        }
        controllerKey.modalPresentationStyle = modalPresentationStyle
        topViewController?.present(controllerKey, animated: true, completion: nil)
    }

    private func transition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        return transition
    }
}


extension UIApplication {

    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

         if let navigationController = controller as? UINavigationController {
             return topViewController(controller: navigationController.visibleViewController)
         }
         if let tabController = controller as? UITabBarController {
             if let selected = tabController.selectedViewController {
                 return topViewController(controller: selected)
             }
         }
         if let pageViewController = controller as? UIPageViewController {
             if let currentPage = pageViewController.viewControllers?.first {
                 return topViewController(controller: currentPage)
             }
         }
         if let presented = controller?.presentedViewController {
             return topViewController(controller: presented)
         }
         return controller
     }

     class func rootViewController() -> UIViewController? {
         return UIApplication.shared.keyWindow?.rootViewController
     }
}
