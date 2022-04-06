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
        observeBitrates()
    }
    
    private func observeBitrates() {
        let builder = ManifestBuilder().parse(playbackURL)
        let playlist = builder.playlists
        
        for (index, object) in playlist.enumerated() {
            if object.bandwidth > 0 {
                //availableBandwidthList.append(Double(object.bandwidth))
                
                print("Play List  Information - Starts")
                print("Playlist \(index + 1)")
                print(object.bandwidth)
                print(object.resolution ?? "No Resolution Value")
                print("Play List  Information - End")
            } else {
                
            }
        }
    }
    
    public func setPreferredPeakBitrate(bitrate: Double) {
        self.av_playerItem.preferredPeakBitRate = bitrate
    }
    
    public func setPreferredMaximumResolution(resolution: CGSize) {
        self.av_playerItem.preferredMaximumResolution = resolution
    }
    
    public func setAssetLoaderDelegate(delegate: IQAssetLoaderDelegate) {
        self.assetLoader.delegate = delegate
    }
    
    public func duration() -> TimeInterval {
        return CMTimeGetSeconds(av_playerItem.asset.duration)
    }
    
    func seekForwardTimeInterval() -> TimeInterval {
        switch options.seekForward {
        case .durationRatio(let ratio):
            return duration() * Double(ratio)
        case .position(let position):
            return position
        }
    }
}

//MARK: Observers functions on IQPlayerItem
extension IQPlayerItem {
    
    func addObservers() {
        
    }
    
}
