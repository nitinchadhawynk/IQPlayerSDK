//
//  IQPlayableAction.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVKit

public protocol IQPlayerControlActionDelegate {
    
    
    func play()
    func pause()
    func setMuted(enabled: Bool)
    func startPip()
}
