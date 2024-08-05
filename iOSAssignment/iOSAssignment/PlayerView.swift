//
//  PlayerView.swift
//  iOSAssignment
//
//  Created by Thukaram on 03/08/24.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
//    private var looper: AVPlayer?
    private var thumbnailImageView: UIImageView?
    var videoCompleted: ((Int) -> Void)?
    var viewIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerView()
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem)

    }
    
    private func setupPlayerView() {
        translatesAutoresizingMaskIntoConstraints = false
        // Initialize the player layer
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspect
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        // Initialize the thumbnail image view
        thumbnailImageView = UIImageView()
        thumbnailImageView?.contentMode = .scaleAspectFill
        thumbnailImageView?.clipsToBounds = true
        
        if let thumbnailImageView = thumbnailImageView {
            addSubview(thumbnailImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        thumbnailImageView?.frame = bounds
    }
    
    func configure(with url: String?, completionHandle: @escaping () -> Void ) {
        if let videoURL = url {
            
            VideoCacheManager.shared.getVideoData(from: videoURL) { [weak self] (data, error) in
                if let error = error {
                    print("Error fetching video: ", error.localizedDescription)
                    return
                }
                completionHandle()
                guard let data = data else { return }
                DispatchQueue.main.async {
                    /*let item = AVPlayerItem(url: data)
                    self?.player = AVQueuePlayer(playerItem: item)
                    guard let playerRef =  self?.player else { return }*/
                    self?.player = AVPlayer(url: data)
                    self?.playerLayer?.player = self?.player
                    self?.player?.rate = 2.0
//                    self?.player?.play()
                }
            }
            
        }
    }
    
    func loadThumbnail(with url: URL?) {
        // Load the thumbnail image
        if let thumbnailURL = url {
            URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.thumbnailImageView?.image = image
                    }
                }
            }.resume()
        }
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        videoCompleted?(viewIndex)
    }

}
