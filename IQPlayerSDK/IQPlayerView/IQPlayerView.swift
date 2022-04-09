//
//  IQPlayerView.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import UIKit
import AVKit

public typealias IQPlayerProtocol = IQPlayerControlActionDelegate & IQPlayerViewDelegate

public class IQPlayerView: UIView {
    
    private var playerItem: IQPlayerItem
    
    var player: IQPlayer
    
    private var output: IQPlaybackOutputManager!
    
    private var loader: AcitivityIndicatorView?
    
    public init(frame: CGRect, playerItem: IQPlayerItem) {
        self.playerItem = playerItem
        self.player = IQPlayer(playerItem: playerItem)
        super.init(frame: frame)
        output = IQPlaybackOutputManager(playerView: self)
        configurePlayerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        player.layer.frame = bounds
    }
    
    private func configurePlayerView() {
        self.playerItem.output = output
        self.player.output = output
        addPlayerLayer()
        addListenerIfDefaultPlaybackLoaderEnabled()
    }
    
    private func addPlayerLayer() {
        layer.addSublayer(player.layer)
        if playerItem.autoPlay {
            player.play()
        }
    }
    
    public func layer() -> CALayer {
        return player.layer
    }
    
    public func setDelegate(client: IQPlayerPlaybackConsumer) {
        self.output.append(listener: client)
    }
    
    deinit {
        print("NC: IQPlayerView Deallocated")
    }
}

extension IQPlayerView: IQVideoPlayerInterface {
    
    var currentTime: Double {
        return player.currentTime
    }
    
    public func play() {
        player.play()
    }
    
    public func pause() {
        player.pause()
    }
    
    public func seek(to time: TimeInterval) {
        player.seek(to: time)
    }
    
    public func seekToLive() {
        if let range = playerItem.getSeekableTimeRanges(), let endRange = range.last {
            seek(to: CMTimeGetSeconds(endRange.end))
        }
    }
    
    public func reset() {
        player.reset()
    }
    
    public func stop() {
        player.pause()
    }
    
    public func duration() -> TimeInterval {
        return playerItem.duration()
    }
        
    public var isMuted: Bool {
        get { return player.isMuted }
        set { player.isMuted = newValue }
    }
    
    public func moveForward() {
        player.seekForwardAndPlay(play: true)
    }
    
    public func moveBackward() {
        player.seekBackwardAndPlay(play: true)
    }
    
    public func select(gravity: IQVideoGravity) {
        player.select(gravity: gravity)
    }
}

extension IQPlayerView: IQPlayerPlaybackConsumer {
    
    private func addListenerIfDefaultPlaybackLoaderEnabled() {
        guard playerItem.options.isPlayerLoaderEnabled else { return }
        output.append(listener: self)
    }
    
    public func playback(playerView: IQPlayerView, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent) {
        
        guard playerItem.options.isPlayerLoaderEnabled else { return }
        
        switch event {
        case .playerItemNotLoading:
            hideLoader()
            
        case .playerItemloading:
            showLoader()
            
        default:
            break
        }
    }
    
    
    
    func showLoader() {
        if loader == nil {
            self.loader = AcitivityIndicatorView(view: self)
        }
        loader?.show()
    }
    
    func hideLoader() {
        loader?.hide()
    }
}
