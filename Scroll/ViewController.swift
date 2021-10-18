//
//  ViewController.swift
//  Scroll
//
//  Created by Sandy Ambarita on 18/10/21.
//

import UIKit

protocol ScrollViewContainingDelegate: NSObject {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

class ViewController: UIViewController {

    private lazy var pageViewController: PageViewController = {
        let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        pageViewController.scrollDelegate = self
        return pageViewController
    }()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewTop: NSLayoutConstraint!
    @IBOutlet weak var parentScrollView: UIScrollView!
    
    
    var childScrollView: UIScrollView?
    var goingUp: Bool?
    var childScrollingDownDueToParent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentScrollView.delegate = self
        initializePageViewController()
    }

    private func initializePageViewController() {
        self.addChild(pageViewController)
        self.containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
    }

}

extension ViewController: UIScrollViewDelegate, ScrollViewContainingDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let parentViewMaxContentYOffset = parentScrollView.contentSize.height - parentScrollView.frame.height
        
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        if goingUp! {
            if scrollView != parentScrollView {
                if parentScrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    parentScrollView.contentOffset.y = max(min(parentScrollView.contentOffset.y + scrollView.contentOffset.y, parentViewMaxContentYOffset), 0)
                    scrollView.contentOffset.y = 0
                }
                childScrollView = scrollView
            }
        } else {
            if scrollView == parentScrollView {
                if childScrollView?.contentOffset.y ?? 0 > 0 && parentScrollView.contentOffset.y < parentViewMaxContentYOffset {
                    childScrollingDownDueToParent = true
                    childScrollView?.contentOffset.y = max(childScrollView!.contentOffset.y - (parentViewMaxContentYOffset - parentScrollView.contentOffset.y), 0)
                    parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            } else {
                if scrollView.contentOffset.y < 0 && parentScrollView.contentOffset.y > 0 {
                    parentScrollView.contentOffset.y = max(parentScrollView.contentOffset.y - abs(scrollView.contentOffset.y), 0)
                    print("parentScrollView.contentOffset.y\(parentScrollView.contentOffset.y)")
                }
                childScrollView = scrollView
            }
        }
        
        
        
    }
}

