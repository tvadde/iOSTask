//
//  ViewController.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(MyCell.self, forCellReuseIdentifier: MyCell.identifier)
        
        viewModel.getReelsData { [weak self]  in
            self?.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.reels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellIdentifier", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.identifier, for: indexPath) as! MyCell
        cell.setupCellData(self.viewModel.reels?[indexPath.row].reels)
        return cell
    }
}

