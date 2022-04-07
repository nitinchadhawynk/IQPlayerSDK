//
//  IQPlayerItem+Bitrates.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 08/04/22.
//

import Foundation
import UIKit

struct IQPlayerBitrate {
    var bitrate: Int64
    var resolution: CGSize
}

extension IQPlayerItem {
    
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
}
