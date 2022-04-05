//
//  IQPlayerViewController.swift
//  ATPlayerClient
//
//  Created by Nitin Chadha on 03/04/22.
//

import UIKit
import IQPlayerSDK
import AVKit

public protocol PictureInPictureDelegate {
    func presentViewController(vc: UIViewController, completion: @escaping (Bool) -> Void)
}

public class IQPlayerViewController: UIViewController {
    
    private var item: IQPlayerItem
    private var playerView: IQPlayerView?
    private var button: UIButton?
    public var pipDelegate: PictureInPictureDelegate?
    public var outputDelegate: IQPlayerPlaybackConsumer?
    var bottomControls: IQBottomControls?
    
    private var pictureInPictureController: AVPictureInPictureController?
    
    public init(playerItem: IQPlayerItem) {
        self.item = playerItem
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    private func addPlayerView() {
        self.playerView = IQPlayerView(frame: .zero, playerItem: item)
        guard let playerView = playerView else { return }
        if let consumerDelegate = outputDelegate {
            playerView.setDelegate(client: consumerDelegate)
        }
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomControls = IQBottomControls(frame: .zero)
        bottomControls?.delegate = self
        bottomControls?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomControls!)
        NSLayoutConstraint.activate([
            bottomControls!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomControls!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            bottomControls!.heightAnchor.constraint(equalToConstant: 50),
            bottomControls!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        view.bringSubviewToFront(bottomControls!)
        
        
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
        addPlayerView()
        view.backgroundColor = .black
    }
    
    deinit {
        print("IQPLayerViewController DEINIT")
    }
}

extension IQPlayerViewController: IQBottomControlDelegate {
    func bottomControlViewActionPerformed(action: IQButtonControlAction) {
        switch action {
        case .play:
            play()
        case .pause:
            pause()
        case .pip(_):
            startPip()
        case .share:
            break
        case .mute(let bool):
            playerView?.isMuted = bool
        case .seek(let interval):
            playerView?.seek(to: interval)
        case .back:
            dismiss(animated: true)
        }
    }
}

extension IQPlayerViewController {
    
    public func setMuted(enabled: Bool) {
        playerView?.isMuted = enabled
    }
    
    public func play() {
        playerView?.play()
    }
    
    public func pause() {
        playerView?.pause()
    }
    
    @objc public func startPip() {
        pictureInPictureController?.startPictureInPicture()
    }
}

extension IQPlayerViewController: AVPictureInPictureControllerDelegate {
    public func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        
        print("pictureInPictureControllerDidStartPictureInPicture")
    }
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("restoreUserInterfaceForPictureInPictureStopWithCompletionHandler")
        if let vc = activeCustomPlayerViewControllers.first {
            pipDelegate?.presentViewController(vc: vc, completion: completionHandler)
        }
        
    }
    
    public func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        activeCustomPlayerViewControllers.append(self)
        dismiss(animated: true)
        print("pictureInPictureControllerWillStartPictureInPicture")
    }
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("pictureInPictureController")
        guard activeCustomPlayerViewControllers.isEmpty == false else { return }
        activeCustomPlayerViewControllers.remove(at: activeCustomPlayerViewControllers.firstIndex(of: self) ?? 0)
    }
    
    
}

var activeCustomPlayerViewControllers = [UIViewController]()
