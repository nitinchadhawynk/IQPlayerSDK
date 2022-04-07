//
//  IQPlayerItem+Live.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 08/04/22.
//

import Foundation
import CoreMedia

public extension IQPlayerItem {
    
    func getSeekableTimeRanges() -> [CMTimeRange]? {
        return av_playerItem.seekableTimeRanges as? [CMTimeRange]
    }
    
    func seekToLive() {
        guard let lastRange = av_playerItem.seekableTimeRanges.last else {
            return
        }
        
        
    }
    
    func handleSafeLifeLiveContentPlay() {
//        let supportsDVR
//        if (supportsDVR == true), let player = player, let lastObject = player.currentItem?.seekableTimeRanges.last as? CMTimeRange {
//            let seekDelta: Double = Double(safeLive)
//            let endTime = CMTimeGetSeconds(lastObject.end)
//            let newPosition: Double = endTime - seekDelta
//            let destinationTime = CMTimeMakeWithSeconds(newPosition, preferredTimescale: Int32(NSEC_PER_SEC))
//            player.seek(to: destinationTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//            playerDelegate?.updatePlayingStatus(status: .live)
//        }
    }
    
}
