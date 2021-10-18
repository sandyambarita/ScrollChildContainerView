//
//  PageViewController.swift
//  Scroll
//
//  Created by Sandy Ambarita on 18/10/21.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {
   var pageControl = UIPageControl()
    weak var scrollDelegate: ScrollViewContainingDelegate?

    lazy var portoViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "ChildViewController")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstViewController = self.portoViewControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.configurePageControl()
        self.isPagingEnabled = false
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = portoViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.isHidden = true
        self.view.addSubview(pageControl)
    }
    
    func newVc(viewController: String) -> UIViewController {
        if let vc = storyboard!.instantiateViewController(withIdentifier: viewController) as? ChildViewController {
            vc.scrollDelegate = scrollDelegate
            return vc
        }
        return UIViewController()
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = portoViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard portoViewControllers.count > previousIndex else { return nil}
        return portoViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = portoViewControllers.firstIndex(of: viewController) else { return nil}
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < portoViewControllers.count else { return nil }
        guard portoViewControllers.count > nextIndex else { return nil }
        return portoViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = portoViewControllers.firstIndex(of: pageContentViewController)!
  
    }
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
    
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

