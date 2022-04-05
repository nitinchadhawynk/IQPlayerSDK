//
//  ContentView.swift
//  IQPlayerSampleApp
//
//  Created by Nitin Chadha on 03/04/22.
//

import SwiftUI
import IQPlayerSDK

struct SampleApplicationPlayerViewModel {
    
    var playerItem: IQPlayerItem
    let assetLoaderHandler = DRMAssetLoaderHandler()
    
    init() {
        //DRM
        //let url = URL(string: "https://xstreamdrm.sonyliv.com/HLS/5f6d6cca-c548-4056-a513-bf598aca8c32/1556784378_movie_originals_salute_drm_hindi_20220315T163540.m3u8?contentId=1000165133&cpCustomerId=2112221148235284018&deviceId=AIRTELXSTREAM-Server&hdnea=exp%3D1648334146%7Eacl%3D*%7Eid%3D15567843782112221148235284018%7Ehmac%3D1a10e043ee59abfd0ee966a11232796a9d1ec69b7b6329aeb5a844cb8ccb64aa&partner=AirtelXtreme&partnerId=1556784378&platform=ios&sku_name=airtel_ala_12m_liv_premium%2Cairtel_mega_12m_liv_premium&user-agent=Apache-HttpClient%2F4.5.10+%28Java%2F1.8.0_171%29")!
        
        //VOD
        let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!
        let playerItem = IQPlayerItem(playbackURL: url)
        //playerItem.setAssetLoaderDelegate(delegate: assetLoaderHandler)
        self.playerItem = playerItem
        //LIVE
        //let url = URL(string: "https://liveb.streamready.in/rajmusixkannada/smil:common.smil/playlist.m3u8?DVR&Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHBzOi8vbGl2ZWIuc3RyZWFtcmVhZHkuaW4vcmFqbXVzaXhrYW5uYWRhL3NtaWw6Y29tbW9uLnNtaWwvKiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTY0ODk3ODQ0MX19fV19&Key-Pair-Id=APKAIWHAQM7JDJRYIKDA&Signature=DCVx9ksbNGMlxutw0hJfUfLM73ES0XxH7ilbBsg77E5oG6yHhfQXYQjBjX8XgPv3o8yIEZ1JHXY6UdWhAZLZlrhYZ~YnuY68vCFdUyYfmDTd4j6ml49D9ZddEX3bq56LaQ5RzpOSZc2WW4Flr-z3XVwccBHz-0CNFCBOUiKsrLiAlC5vZLFKBbJJktubI0pv8dnAnZB4BlGjwDIBelbeKLIAh107OfBu9kzgioZSxHjylgGgONbqlXo8fLtuRf3HT7nIMMzm06d~LiZrasOpbU8Wj5ZBd17fGmEeGBAtO3E3DaDQwyrtOSab3Ukk7NENRP-HDtiC2QvroQo~Ba5lIQ__&spid=RAJTV-RAJTV&request-id=BCC40407986445FABC89930B2F254F15&uid=FmxC_dzrUbu7ITFZcR0")
        //let headers = ["Cookie": "CloudFront-Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHBzOi8vbGl2ZWIuc3RyZWFtcmVhZHkuaW4vcmFqbXVzaXhrYW5uYWRhL3NtaWw6Y29tbW9uLnNtaWwvKiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTY0ODk3ODQ0MX19fV19;CloudFront-Key-Pair-Id=APKAIWHAQM7JDJRYIKDA;CloudFront-Signature=DCVx9ksbNGMlxutw0hJfUfLM73ES0XxH7ilbBsg77E5oG6yHhfQXYQjBjX8XgPv3o8yIEZ1JHXY6UdWhAZLZlrhYZ~YnuY68vCFdUyYfmDTd4j6ml49D9ZddEX3bq56LaQ5RzpOSZc2WW4Flr-z3XVwccBHz-0CNFCBOUiKsrLiAlC5vZLFKBbJJktubI0pv8dnAnZB4BlGjwDIBelbeKLIAh107OfBu9kzgioZSxHjylgGgONbqlXo8fLtuRf3HT7nIMMzm06d~LiZrasOpbU8Wj5ZBd17fGmEeGBAtO3E3DaDQwyrtOSab3Ukk7NENRP-HDtiC2QvroQo~Ba5lIQ__;spid=RAJTV-RAJTV;request-id=BCC40407986445FABC89930B2F254F15;uid=FmxC_dzrUbu7ITFZcR0"]
        //self.playerItem = IQPlayerItem(playbackURL: url!, headers: headers)
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
                    swiftUIPlayer.controls?.play()
                }
                Button("Pause") {
                    swiftUIPlayer.controls?.pause()
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
