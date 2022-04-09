//
//  SampleViewController.swift
//  IQPlayerSampleApp
//
//  Created by Nitin Chadha on 08/04/22.
//

import UIKit
import IQPlayerSDK
import IQPlayerClient

class OutputManager: IQPlayerPlaybackConsumer {
    
    func playback(playerView: IQPlayerView, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent) {
            print("NC EVENT : \(event)")
    }
    
    func playback(playerView view: IQPlayerView, didProgressChangedTo progress: TimeInterval, withDuration duration: TimeInterval) {
        print("NC PROGRESS : \(progress) \(duration)")
    }
    
    func playback(view: IQPlayerView, didProgressChangedTo interval: TimeInterval) {
        
    }
    
    func playbackDidEnded(view: IQPlayerView) {
        
    }
    
    func rateChanged(rate: TimeInterval) { }
    func playbackProgressChanged(progress: TimeInterval, duration: TimeInterval) {
        
    }
    func playbackDidEnded() { }
}

class SampleViewController: UIViewController, PictureInPictureDelegate {
    func presentViewController(vc: UIViewController, completion: @escaping (Bool) -> Void) {
        self.present(vc, animated: true) {
            completion(true)
        }
    }
    
    var controller: IQPlayerViewController!
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        button.setTitleColor(self.view.tintColor, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setTitle("Launch Player", for: .normal)
    }
    
    @objc func buttonAction() {
        let item = SampleApplicationPlayerViewModel()
        controller = IQPlayerViewController(playerItem: item.playerItem)
        controller.pipDelegate = self
        controller.outputDelegate = OutputManager()
        present(controller, animated: true)
    }
    
    deinit {
        print("SampleViewController DEINIT")
    }
}
