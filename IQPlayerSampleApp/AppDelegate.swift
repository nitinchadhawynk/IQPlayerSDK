//
//  AppDelegate.swift
//  IQPlayerSampleApp
//
//  Created by Nitin Chadha on 03/04/22.
//

import UIKit
import AVFoundation
import IQPlayerSDK

class DRMAssetLoaderHandler: IQAssetLoaderDelegate {
    
    func assetLoaderRequested(forCertificate response: @escaping (Data?) -> Void) {
        let url = URL(string: "https://partner-contentutility.sonyliv.com/v1/partner-management-ms/getCert?partnerId=1556784378")!
        var dictionary:[String: Any]?
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {
                response(nil)
                return
            }
            
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let certificateString = dictionary?["certificate"] as? String else {
                    response(nil)
                    return
                }
                
                response(Data.init(base64Encoded: certificateString))
            } catch {
                print(error.localizedDescription)
                response(nil)
            }
        }.resume()
    }
    
    func assetLoaderRequested(forCKC spc:Data, response: @escaping (Data?) -> Void) {
        let url = URL(string: "https://fp.service.expressplay.com/hms/fp/rights/?ExpressPlayToken=BgA2T1gfKe0AJDFhZWU2MmNiLTA2YzQtNDFmZC1iZjdkLWRhZDg2NWFlNWNmYwAAAGCk8mHGTJl4oGJiiYpIeZcCHTpknTK3EzzaqkTm6cQIRy6Tig52AH5kATdEVS3_8_vS24EvzEk8L5T6d2Y9cJlGhAb8x4Y1aSpERdgxbaYCve6smTXXTjy_KZIS2uA_z-c0EQ-N6FzjsUZX8kl1ZYPPnGg0OQ")!
        var dictionary:[String: Any]?
        var urlRequest = URLRequest(url: url)

        urlRequest.setValue("format", forHTTPHeaderField: "{\"Content-Type\":\"application/octet-stream\"}")
        urlRequest.setValue("type", forHTTPHeaderField: "json")
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {
                response(nil)
                return
            }
            
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let certificateString = dictionary?["certificate"] as? String else {
                    response(nil)
                    return
                }
                
                response(Data.init(base64Encoded: certificateString))
            } catch {
                print(error.localizedDescription)
                response(nil)
            }
        }.resume()
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(.playback, mode: .moviePlayback)
                } catch {
                    print("Failed to set audioSession category to playback")
                }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

