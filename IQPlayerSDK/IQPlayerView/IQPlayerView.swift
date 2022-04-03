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
    public var player: IQPlayerProtocol
    
    public init(frame: CGRect, playerItem: IQPlayerItem) {
        self.playerItem = playerItem
        #warning("Need better way to inject player from outside")
        self.player = IQPlayer(playerItem: playerItem)
        super.init(frame: frame)
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
        player.play()
    }
    
    public func layer() -> CALayer {
        return player.layer
    }
    
    deinit {
        print("NC: IQPlayerView Deallocated")
    }
}

extension IQPlayerView: IQPlayerControlActionDelegate {
    
    public func setMuted(enabled: Bool) {
        self.player.setMuted(enabled: enabled)
    }
    
    public func play() {
        self.player.play()
    }
        
    public func pause() {
        self.player.pause()
    }
        
    public func startPip() {
        
    }
}
