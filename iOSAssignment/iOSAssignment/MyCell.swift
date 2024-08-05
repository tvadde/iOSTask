//
//  MyCell.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import UIKit
import AVFoundation

class MyCell: UITableViewCell {
    
    static let identifier = "MyCellIdentity"
    private var playerViews = [PlayerView]()
//    private var backgroundColors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow]
    private let group = DispatchGroup()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
    
        for i in 0..<4 {
            let playerView = PlayerView(frame: CGRectZero)
//            playerView.backgroundColor = backgroundColors[i]
            playerViews.append(playerView)
        }
        
        let verticalStack =  UIStackView()
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.spacing = 8
        verticalStack.distribution = .fillEqually
        verticalStack.axis = .vertical
        contentView.addSubview(verticalStack)
        let horizontalStack1 = setupHorizontalStack()
        let horizontalStack2 = setupHorizontalStack()
        verticalStack.addArrangedSubview(horizontalStack1)
        verticalStack.addArrangedSubview(horizontalStack2)
        
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: verticalStack.bottomAnchor, multiplier: 1),
            verticalStack.heightAnchor.constraint(equalToConstant: 392.0)
        ])
        
        horizontalStack1.addArrangedSubview(playerViews[0])
        horizontalStack1.addArrangedSubview(playerViews[1])
        horizontalStack2.addArrangedSubview(playerViews[2])
        horizontalStack2.addArrangedSubview(playerViews[3])
    }
    
    private func setupHorizontalStack() -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.distribution = .fillEqually
        return horizontalStack
    }
    
    func setupCellData(_ reels: [Reel]?) {
        if let reels = reels {
            for (i, reel) in reels.enumerated() {
                let player = playerViews[i]
                if i == 0  {
                    player.player?.play()
                }
//                player.loadThumbnail(with: URL(string: reel.thumbnail ?? ""))
                group.enter()
                player.configure(with: reel.video) { [weak self]  in
                    self?.group.leave()
                }
                player.videoCompleted = { [weak self] (index) in
                    let player = self?.playerViews[i + 1]
                    player?.player?.play()
                }
            }
            group.notify(queue: .main) {
                print("group completed")
            }
        }
    }
}
