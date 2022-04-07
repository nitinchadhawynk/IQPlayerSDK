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
    }
    
    func configurePlayerControls() {
        bottomControls = IQBottomControls(frame: .zero)
        bottomControls?.delegate = self
        bottomControls?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomControls!)
        NSLayoutConstraint.activate([
            bottomControls!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomControls!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            bottomControls!.heightAnchor.constraint(equalToConstant: 100),
            bottomControls!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        view.bringSubviewToFront(bottomControls!)
    }
    
    func configurePIP() {
        if let playerLayer = playerView?.layer() as? AVPlayerLayer,
           AVPictureInPictureController.isPictureInPictureSupported() {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController?.delegate = self
        }
    }
    
    func configureMultiSubtitle() {
        if let audios = item.getAvailableAudios(),
           let firstAudio = audios.last {
            //print("Audios \(audios)")
            item.setAudio(with: firstAudio)
        }
        print("Audios NIL")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        addPlayerView()
        configurePlayerControls()
        configurePIP()
        configureMultiSubtitle()
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
            playerView?.play()
        case .pause:
            playerView?.pause()
        case .pip(_):
            pictureInPictureController?.startPictureInPicture()
        case .share:
            break
        case .mute(let bool):
            playerView?.isMuted = bool
        case .seek(let interval):
            playerView?.seek(to: interval)
        case .back:
            dismiss(animated: true)
            stop()
        case .forward:
            playerView?.moveForward()
        case .backward:
            playerView?.moveBackward()
        }
    }
}

extension IQPlayerViewController {
    
    public func stop() {
        playerView?.removeFromSuperview()
        playerView = nil
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
