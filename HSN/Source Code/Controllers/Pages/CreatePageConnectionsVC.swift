//
//  CreatePageConnectionsVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CreatePageConnectionsVC: UIPageViewController {

    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    var hasCameFrom:HasCameFrom?
    func changeViewController(index: Int,direction:UIPageViewController.NavigationDirection) {
        switch hasCameFrom{
        case .createPage:

                let vc = orderedViewControllers.filter{$0.view.tag == index}
                switch index {
                case 0:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 1:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 2:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                
                default:
                    break
                }
            //}
        
        default:break
        }
        
    }
    
    weak var mydelegate: pageViewControllerProtocal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        switch hasCameFrom{
        case .createPage:
            if let firstViewController = orderedViewControllers.first {
                let vc = firstViewController as? SelectBusinessTypeVC
                //vc?.selectedDoctor = doctorData
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
       
        default:break
        }
        
        mydelegate?.getSelectedPageIndex(with: 0)
    }
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        switch hasCameFrom{
        case .createPage:
            return [self.newVC(name: "SelectBusinessTypeVC"),
                    self.newVC(name:"CreatePageDetailsVC"),self.newVC(name: "CreatePageOverviewVC")]
        
        default:  return [self.newVC(name: "SelectBusinessTypeVC"),
                          self.newVC(name:"CreatePageDetailsVC"),self.newVC(name: "CreatePageOverviewVC")]
        }
        
    }()
    
    
    
    
    private func newVC(name:String) -> UIViewController {
        switch hasCameFrom{
        case .createPage:
            return UIStoryboard(name: Storyboards.kPages, bundle: nil) .
                instantiateViewController(withIdentifier: name)
        default: return UIStoryboard(name: Storyboards.kPages, bundle: nil) .
            instantiateViewController(withIdentifier: name)
        }
        
    }
    
    
}
extension CreatePageConnectionsVC:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.mydelegate?.getSelectedPageIndex(with: pageViewController.viewControllers!.first!.view.tag)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            
            
            return nil
            
            
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}

