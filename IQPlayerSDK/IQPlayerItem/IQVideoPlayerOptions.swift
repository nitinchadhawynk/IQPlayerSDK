//
//  IQVideoPlayerOptions.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 06/04/22.
//

import Foundation

public enum IQPlayerSeek {
    case position(TimeInterval)
    case durationRatio(Float)
}

public protocol IQPlayerItemOptionsProtocol {
    
    var playbackProgressInterval: TimeInterval { get set }
    
    var seekForward: IQPlayerSeek { get set }
        
    var seekBackward: IQPlayerSeek { get set }
    
}

public struct IQPlayerItemOptions: IQPlayerItemOptionsProtocol {
    
    public var playbackProgressInterval: TimeInterval = 0.5
    
    public var seekForward: IQPlayerSeek = .position(10.0)
    
    public var seekBackward: IQPlayerSeek = .position(10.0)
    
}
