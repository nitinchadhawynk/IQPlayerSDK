//
//  IQPlayerItem.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVFoundation

public struct IQPlayerItem {
    
    public var playbackURL: URL
    
    private  var headers: [String: Any]?
    
    ////autoPlay used to start the video playback instantly after loading the asset
    public var autoPlay = true
    
    internal var output: IQPlaybackOutputManager?
    
    public var options: IQPlayerItemOptionsProtocol = IQPlayerItemOptions()
    
    var av_playerItem: AVPlayerItem
    var av_asset: AVURLAsset
    
    var assetLoader: IQAssetLoader
    
    public init(playbackURL: URL, headers: [String: Any]? = nil) {
        self.playbackURL = playbackURL
        self.headers = headers
        var playerHeaders: [String: Any]?
        if let headers = headers {
            playerHeaders = ["AVURLAssetHTTPHeaderFieldsKey": headers]
        }
        self.av_asset = AVURLAsset(url: playbackURL, options: playerHeaders)
        av_playerItem = AVPlayerItem(asset: av_asset)
        
        self.assetLoader = IQAssetLoader(asset: av_asset)
    }
    
    public func setAssetLoaderDelegate(delegate: IQAssetLoaderDelegate) {
        self.assetLoader.delegate = delegate
    }
    
    public func qualitySelected(at bitrate: Double) {
        av_playerItem.preferredPeakBitRate = bitrate * 1000
    }
    
    public func duration() -> TimeInterval {
        return CMTimeGetSeconds(av_playerItem.asset.duration)
    }
}

//MARK: Observers functions on IQPlayerItem
extension IQPlayerItem {
    
    func addObservers() {
        
    }
    
}
