//
//  IQPlayerViewController.swift
//  ATPlayerClient
//
//  Created by Nitin Chadha on 03/04/22.
//

import UIKit
import IQPlayerSDK
import AVKit

public class IQPlayerViewController: UIViewController {
    
    private var item: IQPlayerItem
    private var playerView: IQPlayerView?
    private var button: UIButton?
    
    private var pictureInPictureController: AVPictureInPictureController?
    
    public init(playerItem: IQPlayerItem) {
        self.item = playerItem
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    private func addPlayerView() {
        self.playerView = IQPlayerView(frame: .zero, playerItem: item)
        guard let playerView = playerView else { return }
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
        self.button = button
        button.setTitle("PUP MODEL", for: .normal)
        self.button?.addTarget(self, action: #selector(pipButtonAction(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let playerLayer = playerView.layer() as? AVPlayerLayer {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController?.delegate = self
        }
    }
    
    @objc private func pipButtonAction(sender: UIButton) {
        startPip()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addPlayerView()
    }
}

extension IQPlayerViewController: IQPlayerControlActionDelegate {
    
    public func setMuted(enabled: Bool) {
        playerView?.setMuted(enabled: enabled)
    }
    
    public func play() {
        playerView?.play()
    }
    
    public func pause() {
        playerView?.pause()
    }
    
    public func startPip() {
        pictureInPictureController?.startPictureInPicture()
    }
}

extension IQPlayerViewController: AVPictureInPictureControllerDelegate {
    public func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerDidStartPictureInPicture")
    }
    
    public func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerWillStartPictureInPicture")
    }
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("pictureInPictureController")
    }
}
