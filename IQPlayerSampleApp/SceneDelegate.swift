//
//  SceneDelegate.swift
//  IQPlayerSampleApp
//
//  Created by Nitin Chadha on 03/04/22.
//

import UIKit
import SwiftUI
import IQPlayerClient
import IQPlayerSDK

struct OutputManager: IQPlayerPlaybackConsumer {
    
    func playback(playerView: IQPlayerView, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent) {
            print("NC EVENT : \(event)")
    }
    
    func playback(playerView view: IQPlayerView, didProgressChangedTo progress: TimeInterval, withDuration duration: TimeInterval) {
        print("\(progress) \(duration)")
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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let item = SampleApplicationPlayerViewModel()
            let controller = SampleViewController()
            let rootController = UINavigationController(rootViewController: controller)
            let window = UIWindow(windowScene: windowScene)
            //window.rootViewController = UIHostingController(rootView: contentView)
            window.rootViewController = rootController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

