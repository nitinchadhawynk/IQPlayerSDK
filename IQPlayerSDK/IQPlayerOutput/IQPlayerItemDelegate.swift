//
//  IQPlayerPlaybackConsumer.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 06/04/22.
//

import Foundation

/**
 * Conform to this protocol to receive basic playback information for each session.
 */
public protocol IQPlayerPlaybackConsumer: class {
    
    /**
     * Called with the playerView's playback progress. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param view The playerview making progress.
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(playerView: IQPlayerView, didProgressChangedTo progress: TimeInterval, withDuration duration: TimeInterval)
    
    /**
     * Called when a playback session receives a lifecycle event. This method is
     * called only for lifecycle events that occur after the delegate is set
     *
     * The lifecycle event types are listed along with the
     * IQPlayerLifeCycleEvent enum.
     *
     * @param view The playerView whose lifecycle events were received.
     * @param lifecycleEvent The lifecycle event received from the player.
     */
    func playback(playerView: IQPlayerView, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent)
    
}

extension IQPlayerPlaybackConsumer {
    
    public func playback(playerView: IQPlayerView, didProgressChangedTo progress: TimeInterval, withDuration duration: TimeInterval) { }
    
    func playback(playerView: IQPlayerView, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent) { }
}
