//
//  ChildViewController.swift
//  Scroll
//
//  Created by Sandy Ambarita on 18/10/21.
//

import Foundation
import UIKit

class ChildViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var scrollDelegate: ScrollViewContainingDelegate?
    var cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}

extension ChildViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
}
