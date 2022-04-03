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
    public var contentID: String
    public var headers: [String: Any]?
    
    var av_playerItem: AVPlayerItem
    var av_asset: AVURLAsset
    
    var assetLoader: IQAssetLoader
    
    public init(playbackURL: URL, headers: [String: Any]? = nil) {
        self.playbackURL = playbackURL
        self.headers = headers
        self.contentID = "123"
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
}
