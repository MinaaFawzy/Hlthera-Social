//
//  PageViewControllerJobs.swift
//  HSN
//
//  Created by Prashant Panchal on 24/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import Foundation
//
//  PageVIewController.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
class PageViewControllerJobs: UIPageViewController {
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    var hasCameFrom:HasCameFrom?
//    var hospitalData:HospitalDetailModel?
//    var doctorData:DoctorDetailsModel?
    var data:JobModel = JobModel(data: [:])
    func changeViewController(index: Int,direction:UIPageViewController.NavigationDirection) {
        switch hasCameFrom{
       
        case .createJob:
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
        default:break
        }
        
    }
    
    weak var mydelegate: pageViewControllerProtocal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        switch hasCameFrom{
       
        case .createJob:
            if let firstViewController = orderedViewControllers.first {
                let vc = firstViewController as? EasyApplyContactInfoVC
                vc?.data = data
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
        case .createJob:
            return [self.newVC(name: EasyApplyContactInfoVC.getStoryboardID()),
                    self.newVC(name:EasyApplyResumeVC.getStoryboardID()),self.newVC(name: EasyApplyReviewVC.getStoryboardID())]
        default: return [self.newVC(name: EasyApplyContactInfoVC.getStoryboardID()),
                         self.newVC(name:EasyApplyResumeVC.getStoryboardID()),self.newVC(name: EasyApplyReviewVC.getStoryboardID())]
        }
        
    }()
    
    
    
    
    private func newVC(name:String) -> UIViewController {
        switch hasCameFrom{
        case .createJob:
            return UIStoryboard(name: Storyboards.kJobs, bundle: nil) .
                instantiateViewController(withIdentifier: name)
        default: return UIStoryboard(name: Storyboards.kJobs, bundle: nil) .
            instantiateViewController(withIdentifier: name)
        }
        
    }
    
    
}
extension PageViewControllerJobs:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
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

