//
//  PageVIewController.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
class PageViewController: UIPageViewController {
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
    func changeViewController(index: Int,direction:UIPageViewController.NavigationDirection) {
        switch hasCameFrom{
        case .createPromotion:
//            if index == 4{
//                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: RatingAndReviewVC.getStoryboardID()) as? RatingAndReviewVC else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            else {
                let vc = orderedViewControllers.filter{$0.view.tag == index}
                switch index {
                case 0:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 1:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 2:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 3:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                default:
                    break
                }
            //}
        case .insights:
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
        case .createPromotion:
            if let firstViewController = orderedViewControllers.first {
                let vc = firstViewController as? SelectPromotionGoalVC
                //vc?.selectedDoctor = doctorData
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        case .insights:
            if let firstViewController = orderedViewControllers.first {
                let vc = firstViewController as? SelectPromotionGoalVC
                //vc?.data = hospitalData
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        case .insights:
            if let firstViewController = orderedViewControllers.first {
                let vc = firstViewController as? SelectPromotionGoalVC
                //vc?.data = hospitalData
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
        case .createPromotion:
            return [self.newVC(name: "SelectPromotionGoalVC"),
                    self.newVC(name:"DefineAudienceVC"),self.newVC(name: "SelectBudgetDurationVC"),self.newVC(name: "ReviewPromotionVC")]
        case .insights:
            return [self.newVC(name: "InsightsContentVC"),
                    self.newVC(name:"InsightsActivityVC"),self.newVC(name: "InsightsAudienceVC")]
        default: return [self.newVC(name: "SelectPromotionGoalVC"),
                         self.newVC(name:"DefineAudienceVC"),self.newVC(name: "SelectBudgetDurationVC"),self.newVC(name: "ReviewPromotionVC")]
        }
        
    }()
    
    
    
    
    private func newVC(name:String) -> UIViewController {
        switch hasCameFrom{
        case .createPromotion:
            return UIStoryboard(name: Storyboards.kPromotions, bundle: nil) .
                instantiateViewController(withIdentifier: name)
        case .insights:
            return UIStoryboard(name: Storyboards.kPromotions, bundle: nil) .
                instantiateViewController(withIdentifier: name)
        default: return UIStoryboard(name: Storyboards.kPromotions, bundle: nil) .
            instantiateViewController(withIdentifier: name)
        }
    }
}

extension PageViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
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
protocol pageViewControllerProtocal:UIPageViewControllerDelegate {
    func getSelectedPageIndex(with value:Int)
    
}
