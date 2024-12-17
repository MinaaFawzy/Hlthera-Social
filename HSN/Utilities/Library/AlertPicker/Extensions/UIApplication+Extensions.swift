import UIKit

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? =  UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
    
}

extension UINavigationController {
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        
        return previousViewController
    }
    
}
