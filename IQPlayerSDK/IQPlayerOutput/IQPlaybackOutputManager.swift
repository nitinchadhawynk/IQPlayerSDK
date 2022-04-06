//
//  IQPlaybackOutputManager.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 05/04/22.
//

import UIKit

/**
 * The IQPlaybackOutputManager class provides special handling of different consumer clients
 * and helps in dispatching any event to all the observers.
 */
public class IQPlaybackOutputManager {
    
    /**
     * listeners is the array of all the clients who are observing the playback events.
     * if any event is dispatched by player, then all the listeneres will get notified.
     */
    private var listeners = [IQPlayerPlaybackConsumer]()
    
    /**
     * playerView is used to pass as reference while dispatching
     * any action to the observer.
     */
    private weak var playerView: IQPlayerView?
    
    /**
     * Initializes a IQPlaybackOutputManager. It uses the playerView
     * to keep the reference, pass it to different listeners.
     *
     * @param playerView IQPlayerView to be passed with action
     * @return An initialized instance.
     */
    init(playerView: IQPlayerView) {
        self.playerView = playerView
    }
    
    /**
     * Take a listener as parameter and
     * first class properties on the source are added to the properties dictionary.
     *
     * @param json Dictionary representing the deserialized source.
     * @return The initialized source.
     */
    public func append(listener: IQPlayerPlaybackConsumer) {
        listeners.append(listener)
    }
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(didProgressChangedTo progress: TimeInterval, duration: TimeInterval) {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didProgressChangedTo: progress, withDuration: duration)
        }
    }
    
    /**
     * Called when player is ready to play AVPlayerItem instances.
     * Do not consider as player is going to play the content instantly
     */
    func playbackPlayerReadyToPlay() {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerReadyToPlay)
        }
    }
    
    /**
     * Called when player item is ready to be played.
     * Indicates the player is ready start the playback
     */
    func playbackPlayerItemReadyToPlay() {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemReadyToPlay)
        }
    }
    
    /**
     * Called when player item can no longer be played because of an error. The error is described by the value of
     * the IQPlayerItem's error property.
     * @param error
     * Indicates about the error which has recieved while playing the content.
     * Look for localized and debug description of the error for more clarity.
     */
    func playback(playerItemFailedWithError error: Error?) {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemFailed(error))
        }
    }
    
    /**
     * Indicates that the player can no longer play IQPlayerItem instances because of an error. The error is passed in
     * parameter, Look for localized and debug description of the error for more clarity.
     */
    func playback(playerFailedWithError error: Error?) {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerFailed(error))
        }
    }
    
    /**
     * Indicates that the status of the player is not yet known because it has not tried to load new media resources for
     * playback.
     */
    func playbackPlayerStatusChangedToUnknown() {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerUnknown)
        }
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    func playbackPlayerItemStatusChangedToUnknown() {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemUnknown)
        }
    }
}




