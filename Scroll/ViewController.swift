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
    
    
    var previousOffset: CGFloat = 0
    
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
        print("scrollView.contentOffset.y \(scrollView.contentOffset.y) nav\(navigationView.frame.maxY) max\(parentViewMaxContentYOffset)")
        if scrollView == parentScrollView {
            
        } else {
            if scrollView.contentOffset.y > headerView.frame.height {
                menuView.frame.origin.y = navigationView.frame.minY
            } else {
                headerViewTop.constant = -(scrollView.contentOffset.y)
                menuView.frame.origin.y = headerView.frame.maxY
            }
        }
        
        
    }
}

