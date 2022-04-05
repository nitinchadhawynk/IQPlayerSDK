//
//  IQBottomControls.swift
//  IQPlayerClient
//
//  Created by B0223972 on 05/04/22.
//

import UIKit

enum IQButtonControlAction {
    case play
    case pause
    case pip(Bool)
    case share
    case mute(Bool)
    case seek(CGPoint)
    case back
    
    var title: String {
        switch(self) {
        case .play: return "Play"
        case .pause: return "Pause"
        case .pip(_): return "PIP"
        case .share: return "Share"
        case .mute(_): return "Mute"
        case .seek(_): return "Seek"
        case .back: return "Back"
        }
    }
    
    var tag: Int {
        switch(self) {
        case .play: return 0
        case .pause: return 1
        case .pip(_): return 2
        case .share: return 3
        case .mute(_): return 4
        case .seek(_): return 5
        case .back: return 6
        }
    }
}

protocol IQBottomControlDelegate: AnyObject {
    func bottomControlViewActionPerformed(action: IQButtonControlAction)
}

class IQBottomControls: UIView {
    
    weak var delegate: IQBottomControlDelegate?
    let controls: [IQButtonControlAction] = [.play, .pause, .mute(true), .pip(true), .back]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
        var subViews = [UIView]()
        for control in controls {
            let button = UIButton(frame: .zero)
            button.setTitle(control.title, for: .normal)
            button.sizeToFit()
            button.tag = control.tag
            button.addTarget(self, action: #selector(playButtonAction(sender:)), for: .touchUpInside)
            subViews.append(button)
        }
        
        let stack = UIStackView(arrangedSubviews: subViews)
        stack.spacing = 30
        stack.alignment = .center
        stack.axis = .horizontal
        stack.sizeToFit()
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
    }
    
    @objc func playButtonAction(sender: UIButton) {
        for control in controls where sender.tag == control.tag {
            delegate?.bottomControlViewActionPerformed(action: control)
        }
    }
}
