//
//  Utility.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import UIKit

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

class AcitivityIndicatorView {
    
    var indicator: UIActivityIndicatorView
    
    init(view: UIView) {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.indicator = indicator
    }
    
    func show() {
        indicator.startAnimating()
    }
    
    func hide() {
        indicator.stopAnimating()
    }
}

class IQWeakPlayerPlaybackConsumer {
    
    weak var value : IQPlayerPlaybackConsumer?
    
    init (_ value: IQPlayerPlaybackConsumer) {
        self.value = value
    }
}
