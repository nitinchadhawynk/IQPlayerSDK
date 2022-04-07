//
//  ContentView.swift
//  IQPlayerSampleApp
//
//  Created by Nitin Chadha on 03/04/22.
//

import SwiftUI
import IQPlayerSDK

enum PlaybackType {
    case live
    case vod
    case drm
    case mp4
}

struct SampleApplicationPlayerViewModel {
    
    var playerItem: IQPlayerItem!
    let assetLoaderHandler = DRMAssetLoaderHandler()
    var playback: PlaybackType = PlaybackType.vod
    
    init() {
        
        //DRM
        if playback == .drm {
            let url = URL(string: "https://xstreamdrm.sonyliv.com/HLS/5f6d6cca-c548-4056-a513-bf598aca8c32/1556784378_movie_originals_salute_drm_hindi_20220315T163540.m3u8?contentId=1000165133&cpCustomerId=2112221148235284018&deviceId=AIRTELXSTREAM-Server&hdnea=exp%3D1648334146%7Eacl%3D*%7Eid%3D15567843782112221148235284018%7Ehmac%3D1a10e043ee59abfd0ee966a11232796a9d1ec69b7b6329aeb5a844cb8ccb64aa&partner=AirtelXtreme&partnerId=1556784378&platform=ios&sku_name=airtel_ala_12m_liv_premium%2Cairtel_mega_12m_liv_premium&user-agent=Apache-HttpClient%2F4.5.10+%28Java%2F1.8.0_171%29")!
            
            let playerItem = IQPlayerItem(playbackURL: url)
            playerItem.setAssetLoaderDelegate(delegate: assetLoaderHandler)
            self.playerItem = playerItem
        } else if (playback == .vod || playback == .mp4) {
            let urlString = playback == .mp4 ? "http://techslides.com/demos/sample-videos/small.mp4" : "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
            let url = URL(string: urlString)!
            let playerItem = IQPlayerItem(playbackURL: url)
            self.playerItem = playerItem
        } else {
            //LIVE
            let url = URL(string: "https://liveb.streamready.in/rajdigitalplus/smil:common.smil/playlist.m3u8?DVR&Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHBzOi8vbGl2ZWIuc3RyZWFtcmVhZHkuaW4vcmFqZGlnaXRhbHBsdXMvc21pbDpjb21tb24uc21pbC8qIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNjQ5MzgxNjE2fX19XX0_&Key-Pair-Id=APKAIWHAQM7JDJRYIKDA&Signature=GFMOELIr1PRuPQhM3Pmw3f954IIDYHi19ZFuw82Du6pm3BXOV0NnzpsWLrUX0-CNTvwIHC5BL6ZEX6nNQIizWA79FP4w7R0zzTLy3z5MLdvHZsmS2mF6wGs3I7KrMKwABVKYwhubif-6BDcE68O1GYN6hLAN8300JRpEBxzTgeksSf24ZWUFqXKC1cwaRAolvWW0TE-a~Cef6mjx4YIngl98kNzy9j2tgU2N9S1PNJQtzPFt4rLUaghlUkIsLIR9qr6w38A2urBanyVR1~VrTPvX4kkkT27FDRvQEUEWgCziFAxi2MP-eImGD-4g125ijl3APdxwpeLaArcV~nD5UA__&spid=RAJTV-RAJTV&request-id=41B56633C9CA49979B2F005F6412F97A&uid=FmxC_dzrUbu7ITFZcR0")
            let headers = ["Cookie": "CloudFront-Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHBzOi8vbGl2ZWIuc3RyZWFtcmVhZHkuaW4vcmFqZGlnaXRhbHBsdXMvc21pbDpjb21tb24uc21pbC8qIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNjQ5MzgxNjE2fX19XX0_;CloudFront-Key-Pair-Id=APKAIWHAQM7JDJRYIKDA;CloudFront-Signature=GFMOELIr1PRuPQhM3Pmw3f954IIDYHi19ZFuw82Du6pm3BXOV0NnzpsWLrUX0-CNTvwIHC5BL6ZEX6nNQIizWA79FP4w7R0zzTLy3z5MLdvHZsmS2mF6wGs3I7KrMKwABVKYwhubif-6BDcE68O1GYN6hLAN8300JRpEBxzTgeksSf24ZWUFqXKC1cwaRAolvWW0TE-a~Cef6mjx4YIngl98kNzy9j2tgU2N9S1PNJQtzPFt4rLUaghlUkIsLIR9qr6w38A2urBanyVR1~VrTPvX4kkkT27FDRvQEUEWgCziFAxi2MP-eImGD-4g125ijl3APdxwpeLaArcV~nD5UA__;spid=RAJTV-RAJTV;request-id=41B56633C9CA49979B2F005F6412F97A;uid=FmxC_dzrUbu7ITFZcR0"]
            self.playerItem = IQPlayerItem(playbackURL: url!, headers: headers)
        }
    }
}

struct ContentView: View {
    
    var swiftUIPlayer = SwiftUI_IQPlayerView(playerItem: SampleApplicationPlayerViewModel().playerItem)
    
    @State var currentTime: Double?
    
    var body: some View {
        ZStack {
            Color(.black)
            
            VStack {
                swiftUIPlayer
                    .background(Color.black)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
                    .onAppear {
                        
                    }
                
                Spacer()
            }.background(Color.gray)
            VStack {
                Spacer()
                Text("currentTime \(currentTime ?? 0)")
                Button("Play") {
                    //swiftUIPlayer.controls?.play()
                }
                Button("Pause") {
                    //swiftUIPlayer.controls?.pause()
                }
                Button("Zoom in") {
                    //swiftUIPlayer.controls?.zoomIn()
                }
                Button("Zoom out") {
                    //swiftUIPlayer.controls?.zoomOut()
                }
                Button("Zoom") {
                    //swiftUIPlayer.controls?.moveForward()
                }
                Button("Play") {}
            }.padding(.bottom, 30)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
