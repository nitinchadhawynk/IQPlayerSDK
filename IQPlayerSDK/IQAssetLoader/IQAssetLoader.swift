//
//  IQAssetLoader.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVFoundation

public protocol IQAssetLoaderDelegate {
    
    //IQAssetLoader will request certificate for DRM content, if certificate is already persisted then it can be passed by value in protperty certificateData of IQAssetLoader
    func assetLoaderRequested(forCertificate response: @escaping (Data?) -> Void)
    func assetLoaderRequested(forCKC spc:Data, response: @escaping (Data?) -> Void)
}

class IQAssetLoader: NSObject {
    
    let session: AVContentKeySession = AVContentKeySession(keySystem: .clearKey)
    let queue = DispatchQueue(label: "fairplay.refresher.queue")
    
    var certificateData: Data?
    var delegate: IQAssetLoaderDelegate?
    
    init(asset: AVURLAsset, delegate: IQAssetLoaderDelegate? = nil) {
        super.init()
        self.delegate = delegate
        //createSession()
        asset.resourceLoader.setDelegate(self, queue: queue)
        //session.addContentKeyRecipient(asset)
    }
    
    func createSession() {
        session.setDelegate(self, queue: queue)
        session.processContentKeyRequest(withIdentifier: "contentId", initializationData: nil, options: nil)
    }
    
}

extension IQAssetLoader: AVAssetResourceLoaderDelegate {
 
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        delegate?.assetLoaderRequested(forCertificate: { (certificate) in
            if let certificate = certificate, let spc = self.createSPCForApplicationCertificate(certificate: certificate, loadingRequest: loadingRequest) {
                
            }
        })
        return true
    }
    
    func createSPCForApplicationCertificate(certificate: Data, loadingRequest: AVAssetResourceLoadingRequest) -> Data? {
        guard let assetIDString = loadingRequest.request.url?.host else {
            return nil
        }
        
        guard let assetIDdata = assetIDString.data(using: .utf8) else { return nil }
        do {
            let spc = try loadingRequest.streamingContentKeyRequestData(forApp: certificate, contentIdentifier: assetIDdata, options: nil)
            return spc
        } catch {
            print("Error while creating SPC")
        }
        return nil
    }
    
}

extension IQAssetLoader: AVContentKeySessionDelegate {
    func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVContentKeyRequest) {
        
        //logger.debug("Start persistable content key request")
        // We first check if a url is set in the manifest.
        guard let contentId = keyRequest.identifier as? String, let contentIdData = contentId.data(using: String.Encoding.utf8) else {
            //logger.error("Unable to read contentId.")
            //keyRequest.processContentKeyResponseError(DelegateError.noContentId)
            return
        }
        let certificateData = Data()
        keyRequest.makeStreamingContentKeyRequestData(forApp: certificateData, contentIdentifier: contentIdData, options: [AVAssetResourceLoadingRequestStreamingContentKeyRequestRequiresPersistentKey: true as AnyObject]) { spcData, spcError in
            guard let spcData = spcData else {
                //let error = spcError ?? DelegateError.noSPCData
                //logger.error("Unable to fetch SPC data \(error).")
                keyRequest.processContentKeyResponseError(spcError!)
                return
            }
            //logger.debug("SPC data fetched, requesting CKC")
            let keyServerUrl = URL(string: "www.server.come")
            let stringBody: String = "spc=\(spcData.base64EncodedString())&assetId=\(contentId)"
            var ckcRequest = URLRequest(url: keyServerUrl!)
            ckcRequest.httpMethod = "POST"
            ckcRequest.httpBody = stringBody.data(using: String.Encoding.utf8)
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: ckcRequest) { data, _, error in
                guard let data = data else {
                    //logger.error("Error in response data in CKC request: \(error)")
                    keyRequest.processContentKeyResponseError(error as! Error)
                    return
                }
                // The CKC is correctly returned and is now send to the `AVPlayer` instance so we
                // can continue to play the stream.
                guard let ckcData = Data(base64Encoded: data) else {
                    //logger.error("Can’t create base64 encoded data")
                    //keyRequest.processContentKeyResponseError(DelegateError.ckcFetch)
                    return
                }
                var persistentKeyData: Data?
                do {
                    //keyRequest.persi
                  //  persistentKeyData = try keyRequest.persistableContentKey(fromKeyVendorResponse: data, options: nil)
                } catch {
                    //logger.error("Unable to create persistable content key \(error).")
                    keyRequest.processContentKeyResponseError(error)
                    return
                }
                //AVContentKeyResponse(fairPlayStreamingKeyResponseData: <#T##Data#>)
                //let keyResponse = AVContentKeyResponse(fairPlayStreamingKeyResponseData: <#T##Data#>)
                //let keyResponse = AVContentKeyResponse(fairPlayStreamingKeyResponseData: persistentKeyData)
                //keyRequest.processContentKeyResponse(keyResponse)
                //logger.debug("CKC received, loading complete")
            }.resume()
        }
    }
}
