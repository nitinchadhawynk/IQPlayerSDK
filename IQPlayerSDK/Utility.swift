//
//  Utility.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

func bytesToHumanReadable(bytes: Double) -> String {
    let formatter = ByteCountFormatter()
    
    if (bytes.isNaN || bytes.isInfinite) {
        return "-"
    }
    
    return formatter.string(fromByteCount: Int64(bytes)) + "/s"
}
