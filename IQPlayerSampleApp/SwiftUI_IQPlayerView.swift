//
//  SwiftUI_Helper.swift
//  IQPlayerSampleApp
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation

import Foundation
import SwiftUI
import IQPlayerSDK
import IQPlayerClient

public final class SwiftUI_IQPlayerView: UIViewRepresentable {
    
    public var playerItem: IQPlayerItem
    public var controls: IQPlayerControlActionDelegate?
    
    public init(playerItem: IQPlayerItem) {
        self.playerItem = playerItem
    }
    
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SwiftUI_IQPlayerView>) { }
    
    public func makeUIView(context: Context) -> UIView {
        /*let playerView = IQPlayerView(frame: .zero, playerItem: playerItem)
        self.controls = playerView
        return playerView
        */
        let vc = IQPlayerViewController(playerItem: playerItem)
        self.controls = vc
        return vc.view
        
    }
}

