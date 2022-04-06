//
//  IQPlayer.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVKit
import AVFoundation

class IQPlayer: NSObject, IQPlayerControlActionDelegate, IQPlayerViewDelegate {
    
    private let playerItem: IQPlayerItem
    var isStalling = false
    
    private let av_playerLayer: AVPlayerLayer
    @objc private let av_player: AVPlayer
    
    var output: IQPlaybackOutputManager?
    
    // Used to caclulate stall duration
    fileprivate var stallBeginTime:Int64 = 0
    
    // Last observed bitrate
    fileprivate var lastBitrate:Double = 0
    
    var currentTime: Double {
        return CMTimeGetSeconds(av_player.currentTime())
    }
    
    //MARK: IQPlayerViewDelegate
    var layer: CALayer {
        return av_playerLayer
    }
    
    var isMuted: Bool {
        get {
            return av_player.isMuted
        }
        set {
            av_player.isMuted = newValue
        }
    }
    
    init(playerItem: IQPlayerItem) {
        av_player = AVPlayer(playerItem: playerItem.av_playerItem)
        av_playerLayer = AVPlayerLayer()
        av_playerLayer.player = av_player
        self.playerItem = playerItem
        super.init()
        addObservers()
    }
    
    //MARK: IQPlayerControlActionDelegate
    
    //Signals the desire to begin playback at the current item's natural rate.
    func play() {
        av_player.play()
    }
    
    //Pauses playback
    func pause() {
        av_player.pause()
    }
    
    func setMuted(enabled: Bool) {
        av_player.isMuted = enabled
    }
    
    func startPip() {
        
    }
    
    func seek(to time: TimeInterval) {
        let myTime = CMTime(seconds: time, preferredTimescale: 60000)
        av_player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func reset() {
        av_player.seek(to: CMTime.zero)
    }
    
    deinit {
        print("IQPlayer DEINIT")
    }
}

extension IQPlayer {
    
    func addObservers() {
        
        av_player.addPeriodicTimeObserver(forInterval:
                                            CMTime(seconds: playerItem.options.playbackProgressInterval, preferredTimescale: 1000),
                                          queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let duration = self.av_player.currentItem?.asset.duration ?? CMTime(seconds: 0, preferredTimescale: 1000)
            self.output?.playback(didProgressChangedTo: CMTimeGetSeconds(time),
                                  duration: CMTimeGetSeconds(duration))
        }
        
        // [LOGGING] Add observer for player status
        addObserver(self, forKeyPath: #keyPath(av_player.status), options: [.new, .initial], context: nil)
        
        // [LOGGING] Add observer for playerItem status
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.status), options: [.new, .initial], context: nil)
        
        // [LOGGING] Add observer for playerItem buffer
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackBufferEmpty), options: .new, context: nil)
        
        // [LOGGING] Add observer for monitoring buffer full event
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackBufferFull), options: .new, context: nil)
        
        // [LOGGING] Add observer for monitoring whether the item will likely play through without stalling
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackLikelyToKeepUp), options: .new, context: nil)
        
        // [LOGGING] Provides a collection of time ranges for which the player has the media data readily available
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.loadedTimeRanges), options: .new, context: nil)
        
        // [LOGGING] Indicates whether output is being obscured because of insufficient external protection
        addObserver(self, forKeyPath: #keyPath(av_player.isOutputObscuredDueToInsufficientExternalProtection), options: .new, context: nil)
        
        // [LOGGING] Console message arrived
        //NotificationCenter.default.addObserver(self, selector: #selector(handleConsoleMessageSent(_:)), name: NSNotification.Name.ConsoleMessageSent, object: nil)
        
        // [LOGGING] Item has failed to play to its end time
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: av_player.currentItem)
        
        // [LOGGING] Item has played to its end time
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: av_player.currentItem)
        
        // [LOGGING] Media did not arrive in time to continue playback
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: av_player.currentItem)
        
        // [LOGGING] A new access log entry has been added
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewAccessLogEntry), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: av_player.currentItem)
        
        // [LOGGING] A new error log entry has been added
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: av_player.currentItem)
        
        // [LOGGING] A media selection group changed its selected option
        NotificationCenter.default.addObserver(self, selector: #selector(mediaSelectionDidChange), name: AVPlayerItem.mediaSelectionDidChangeNotification, object: av_player.currentItem)
        
        // [MANDATORY] ContentKey delegate did save a Persistable Content Key
        //NotificationCenter.default.addObserver(self, selector: #selector(handleContentKeyDelegateHasAvailablePersistableContentKey(notification:)), name: .HasAvailablePersistableContentKey, object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        // Player Item Status
        if keyPath == #keyPath(av_player.currentItem.status) {
            let status: AVPlayerItem.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                output?.playbackPlayerItemReadyToPlay()
                writeToConsole("Player item is ready to play", "Playback")
            case .failed:
                output?.playback(playerItemFailedWithError: av_player.currentItem?.error)
                writeToConsole("Player item failed error: \(String(describing: av_player.currentItem?.error?.localizedDescription))\n Debug info: \(String(describing: av_player.currentItem?.error.debugDescription))","Playback")
            case .unknown:
                writeToConsole("Player item is not yet ready","Playback")
            @unknown default:
                writeToConsole("UNEXPECTED STATUS","Playback")
            }
        }
        
        // Player Status
        if keyPath == #keyPath(av_player.status) {
            let status: AVPlayer.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayer.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                output?.playbackPlayerReadyToPlay()
                writeToConsole("Player is ready to play AVPlayerItem instances","Playback")
            case .failed:
                output?.playback(playerFailedWithError: av_player.error)
                writeToConsole("Player can no longer play AVPlayerItem instances because of an error: \(String(describing: av_player.error?.localizedDescription))\n Debug info: \(String(describing: av_player.error.debugDescription))","Playback")
            case .unknown:
                writeToConsole("Player is not yet ready","Playback")
            @unknown default:
                writeToConsole("UNEXPECTED STATUS","Playback")
            }
        }
        
        /*
         This property communicates a prediction of playability. Factors considered in this prediction
         include I/O throughput and media decode performance. It is possible for playbackLikelyToKeepUp to
         indicate NO while the property playbackBufferFull indicates YES. In this event the playback buffer has
         reached capacity but there isn't the statistical data to support a prediction that playback is likely to
         keep up. It is left to the application programmer to decide to continue media playback or not.
         */
        
        if keyPath == #keyPath(av_player.currentItem.isPlaybackBufferEmpty) {
            
            guard let currentItem = av_player.currentItem else {
                return
            }
            
            if currentItem.isPlaybackBufferEmpty {
                writeToConsole("Data buffer used for playback is empty. Playback will stall or end","Playback")
            } else {
                writeToConsole("Data buffer used for playback is not empty anymore","Playback")
            }
        }
        
        /*
         This property reports that the data buffer used for playback has reach capacity.
         Despite the playback buffer reaching capacity there might not exist sufficient statistical
         data to support a playbackLikelyToKeepUp prediction of YES. See playbackLikelyToKeepUp above
         */
        if keyPath == #keyPath(av_player.currentItem.isPlaybackBufferFull) {
            
            guard let currentItem = av_player.currentItem else {
                return
            }
            
            if currentItem.isPlaybackBufferFull {
                writeToConsole("Data buffer used for playback is full","Playback")
            } else {
                writeToConsole("Data buffer used for playback is not full anymore","Playback")
            }
        }
        
        /*
         This property communicates a prediction of playability. Factors considered in this prediction
         include I/O throughput and media decode performance. It is possible for playbackLikelyToKeepUp to
         indicate NO while the property playbackBufferFull indicates YES. In this event the playback buffer has
         reached capacity but there isn't the statistical data to support a prediction that playback is likely to
         keep up. It is left to the application programmer to decide to continue media playback or not.
         See playbackBufferFull below.
         */
        if keyPath == #keyPath(av_player.currentItem.isPlaybackLikelyToKeepUp) {
            guard let currentItem = av_player.currentItem else {
                return
            }
            
            if currentItem.isPlaybackLikelyToKeepUp {
                writeToConsole("Playback will likely to keep up","Playback")
                
                if isStalling {
                    isStalling = false
                    let stallDurationMs: Int64 = Date().toMillis()! - stallBeginTime
                    writeToConsole("Stall took \(stallDurationMs) ms","Playback")
                }
                
            } else {
                writeToConsole("Playback will likey to fail","Playback")
            }
        }
        
        if keyPath == #keyPath(av_player.isOutputObscuredDueToInsufficientExternalProtection) {
            if av_player.isOutputObscuredDueToInsufficientExternalProtection {
                writeToConsole("Output is being obscured because current device configuration does not meet the requirements for protecting the item","Playback")
            } else {
                writeToConsole("OK. Device configuration meets the requirements for protecting the item","Playback")
            }
        }
    }
    
    
    // [LOGGING]
    // Item has failed to play to its end time
    @objc func itemFailedToPlayToEndTime(_ notification: Notification) {
        let error:Error? = notification.userInfo!["AVPlayerItemFailedToPlayToEndTimeErrorKey"] as? Error
        
        writeToConsole("Item failed to play to the end. Error: \(String(describing:error?.localizedDescription)), error: \(String(describing: error))",  "Playback")
    }
    
    // Item has played to its end time
    // [LOGGING]
    @objc func itemDidPlayToEndTime(_ notification: Notification) {
        writeToConsole("Item has played to its end time",  "Playback")
    }
    
    // Media did not arrive in time to continue playback
    // [LOGGING]
    @objc func itemPlaybackStalled(_ notification: Notification) {
        isStalling = true
        // Used to calculate time delta of the stall which is printed to the Console
        stallBeginTime = Date().toMillis()!
        
        writeToConsole("Stall occured. Media did not arrive in time to continue playback",  "Playback")
    }
    
    // A new access log entry has been added
    // [LOGGING]
    @objc func itemNewAccessLogEntry(_ notification: Notification) {
        
        guard let playerItem = notification.object as? AVPlayerItem,
              let lastEvent = playerItem.accessLog()?.events.last else {
            return
        }
        
        if lastEvent.indicatedBitrate != lastBitrate {
            writeToConsole("Bitrate changed to \(bytesToHumanReadable(bytes: lastEvent.indicatedBitrate))",  "Playback")
        }
        
        writeToConsole("""
                \n-------------- NEW PLAYER ACCESS LOG ENTRY -------------- \n \
                URI: \(String(describing: lastEvent.uri)) \n \
                PLAYBACK SESSION ID: \(String(describing: lastEvent.playbackSessionID)) \n \
                PLAYBACK START DATE: \(String(describing: lastEvent.playbackStartDate)) \n \
                PLAYBACK START OFFSET: \(lastEvent.playbackStartOffset) \n \
                PLAYBACK TYPE: \(String(describing: lastEvent.playbackType)) \n \
                INDICATED BITRATE (ADVERTISED BY SERVER): \(bytesToHumanReadable(bytes: lastEvent.indicatedBitrate)) \n \
                OBSERVED BITRATE (ACROSS ALL MEDIA DOWNLOADED): \(bytesToHumanReadable(bytes: lastEvent.observedBitrate)) \n \
                AVERAGE BITRATE REQUIRED TO PLAY THE STREAM (ADVERTISED BY SERVER): \(bytesToHumanReadable(bytes: lastEvent.indicatedAverageBitrate)) \n \
                BYTES TRANSFERRED: \(bytesToHumanReadable(bytes: Double(lastEvent.numberOfBytesTransferred))) \n \
                STARTUP TIME: \(lastEvent.startupTime) \n \
                DURATION WATCHED: \(lastEvent.durationWatched) \n \
                NUMBER OF DROPPED VIDEO FRAMES: \(lastEvent.numberOfDroppedVideoFrames) \n \
                NUMBER OF STALLS: \(lastEvent.numberOfStalls) \n \
                NUMBER OF TIMES DOWNLOADING SEGMENTS TOOK TOO LONG: \(lastEvent.downloadOverdue) \n \
                TOTAL DURATION OF DOWNLOADED SEGMENTS: \(lastEvent.segmentsDownloadedDuration)
            """,  "Playback")
    }
    
    // A new error log entry has been added
    // [LOGGING]
    @objc func itemNewErrorLogEntry(_ notification: Notification) {
        
        guard let playerItem = notification.object as? AVPlayerItem,
              let lastEvent = playerItem.errorLog()?.events.last else {
            return
        }
        
        writeToConsole("""
                \n-------------- NEW PLAYER ERROR LOG ENTRY -------------- \n \
                URI: \(String(describing: lastEvent.uri)) \n \
                DATE: \(String(describing: lastEvent.date)) \n \
                SERVER: \(String(describing: lastEvent.serverAddress)) \n \
                ERROR STATUS CODE: \(String(describing: lastEvent.errorStatusCode)) \n \
                ERROR DOMAIN: \(String(describing: lastEvent.errorDomain)) \n \
                ERROR COMMENT: \(String(describing: lastEvent.errorComment)) \n \
                PLAYBACK SESSION ID: \(String(describing: lastEvent.playbackSessionID))
            """,  "Playback")
    }
    
    // A media selection group changed its selected option
    // [LOGGING]
    @objc func mediaSelectionDidChange(_ notification: Notification) {
        writeToConsole("A media selection group changed its selected option",  "Playback")
    }
    
    // Begin with stream download process after .ContentKeyDelegateHasAvailablePersistableContentKey notification is received
    
}


func writeToConsole(_ message: String, _ category: String) {
    print(message)
}
