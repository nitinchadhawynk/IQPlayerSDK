//
//  IQVideoPlayerOptions.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 06/04/22.
//

import Foundation
import AVFoundation

public enum IQPlayerSeek {
    case position(TimeInterval)
    case durationRatio(Float)
}

public enum IQVideoGravity {
    
    case fill
    
    case aspectFit
    
    case aspectFill
    
    internal var avGravity: AVLayerVideoGravity  {
        switch self {
        case .fill:
            return .resize
        case .aspectFit:
            return .resizeAspect
        case .aspectFill:
            return .resizeAspectFill
        }
    }
}

public protocol IQPlayerItemOptionsProtocol {
    
    var playbackProgressInterval: TimeInterval { get set }
    
    var seekForward: IQPlayerSeek { get set }
        
    var seekBackward: IQPlayerSeek { get set }
    
    var isPlayerLoaderEnabled: Bool { get set }
}

public struct IQPlayerItemOptions: IQPlayerItemOptionsProtocol {
    
    public var playbackProgressInterval: TimeInterval = 2
    
    public var seekForward: IQPlayerSeek = .position(10.0)
    
    public var seekBackward: IQPlayerSeek = .position(10.0)
    
    public var isPlayerLoaderEnabled: Bool = true
    
}
