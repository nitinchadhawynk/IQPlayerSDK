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
    weak var playerView: IQPlayerView?
    
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
    public func append(client: IQPlayerPlaybackConsumer) {
        listeners.append(client)
    }
    
    /// Called when a timebase rate change occurs.
    func rateChanged(rate: TimeInterval) {
        //clients.forEach {
        //$0.rateChanged(rate: rate)
        //}
    }
    
    func playbackDidEnded() {
        //clients.forEach {
        //$0.playbackDidEnded()
        //}
    }
    
    /// Start playback from beginning
    func resetPlayHead() {
        
    }
    
    func playbackProgressChanged(progress: TimeInterval, duration: TimeInterval) {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didProgressChangedTo: progress, withDuration: duration)
        }
    }
    
    
    func playerItemIsReadyToPlay() {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemReadyToPlay)
        }
    }
    
    
    func playerReadyToPlay() {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerReadyToPlay)
        }
    }
    
    func playerItemFailed(error: Error?) {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemFailed(error))
        }
    }
    
    func playerFailed(error: Error?) {
        guard let view = playerView else { return }
        listeners.forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerFailed(error))
        }
    }
    
    func playerItemUnknown() {
        
    }
    
}




