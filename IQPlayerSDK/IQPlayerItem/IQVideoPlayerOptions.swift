//
//  IQVideoPlayerOptions.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 06/04/22.
//

import Foundation

public protocol IQPlayerItemOptionsProtocol {
    
    var playbackProgressInterval: TimeInterval { get set }
    
}

public struct IQPlayerItemOptions: IQPlayerItemOptionsProtocol {
    
    public var playbackProgressInterval: TimeInterval = 0.5
    
}
