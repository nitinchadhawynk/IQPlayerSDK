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
    
    private var _isMuted: Bool = false
    private var _isPaused: Bool = false
    
    private var playerItem: IQPlayerItem
    var player: IQPlayer
    
    private var output: IQPlaybackOutputManager!
    
    public init(frame: CGRect, playerItem: IQPlayerItem) {
        self.playerItem = playerItem
        self.player = IQPlayer(playerItem: playerItem)
        super.init(frame: frame)
        output = IQPlaybackOutputManager(playerView: self)
        self.playerItem.output = output
        self.player.output = output
        addPlayerLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        player.layer.frame = bounds
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
    
    public func reset() {
        player.reset()
    }
    
    public func duration() -> TimeInterval {
        return playerItem.duration()
    }
        
    public var isMuted: Bool {
        get { return player.isMuted }
        set { player.isMuted = newValue }
    }
    
    public var isPaused: Bool {
        get { return _isPaused }
        set { _isPaused = newValue }
    }
    
    public func qualitySelected(with bitrate: Int) {
        let playedTime = currentTime
        playerItem.qualitySelected(at: 10)
        
        /*
        AVPlayerItem *currentItem = self.fairPlayVideoPlayback.player.currentItem;
        NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
        NSLog(@"Bitrate Selected from player- %d",bitrate);
        [currentItem setPreferredPeakBitRate:bitrate*1000];
        [self.fairPlayVideoPlayback seekToTimeInterval:currentTime];
        [self.fairPlayVideoPlayback play];
         */
    }
}
