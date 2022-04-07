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
    case seek(TimeInterval)
    case back
    case forward
    case backward
    case custom(String, Int)
    case fill
    case aspectFit
    case aspectFill
    
    var title: String {
        switch(self) {
        case .play: return "Play"
        case .pause: return "Pause"
        case .pip(_): return "PIP"
        case .share: return "Share"
        case .mute(_): return "Mute"
        case .seek(_): return "Seek"
        case .back: return "Back"
        case .forward: return " >> "
        case .backward: return " << "
        case .fill: return "fill"
        case .aspectFit: return "aspectFit"
        case .aspectFill: return "aspectFill"
        case .custom(let title, _): return title
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
        case .forward: return 7
        case .backward: return 8
        case .custom(_, let tag): return tag
        case .fill: return 100
        case .aspectFit: return 101
        case .aspectFill: return 102
        }
    }
}

protocol IQBottomControlDelegate: AnyObject {
    func bottomControlViewActionPerformed(action: IQButtonControlAction)
}

class IQBottomControls: UIView {
    
    weak var delegate: IQBottomControlDelegate?
    var controls: [IQButtonControlAction] = [.play, .pause, .forward, .backward, .pip(true), .back]
    var bottomControlArray = [[IQButtonControlAction]]()
    
    init(frame: CGRect, customButtons: [[IQButtonControlAction]]? = nil) {
        super.init(frame: frame)
        if let customButtons = customButtons {
            bottomControlArray = customButtons
        }
        addButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons() {
        var subViews = [UIView]()
        var stackViews = [UIStackView]()
        for control in controls {
            let button = UIButton(frame: .zero)
            button.setTitle(control.title, for: .normal)
            button.sizeToFit()
            button.backgroundColor = .darkGray
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
        //addSubview(stack)
        stackViews.append(stack)
        
        for bottomControl in bottomControlArray {
            
            var newsubViews = [UIView]()
            for control in bottomControl {
                let button = UIButton(frame: .zero)
                button.setTitle(control.title, for: .normal)
                button.sizeToFit()
                button.backgroundColor = .darkGray
                button.tag = control.tag
                button.addTarget(self, action: #selector(playButtonAction(sender:)), for: .touchUpInside)
                newsubViews.append(button)
            }
            
            let new_stack = UIStackView(arrangedSubviews: newsubViews)
            new_stack.spacing = 30
            new_stack.alignment = .center
            new_stack.axis = .horizontal
            new_stack.sizeToFit()
            new_stack.translatesAutoresizingMaskIntoConstraints = false
            stackViews.append(new_stack)
            
        }
        
        let newStackView = UIStackView(arrangedSubviews: stackViews)
        newStackView.axis = .vertical
        newStackView.spacing = 10
        newStackView.alignment = .center
        newStackView.sizeToFit()
        newStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newStackView)
        newStackView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            newStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            newStackView.topAnchor.constraint(equalTo: topAnchor),
            newStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    @objc func playButtonAction(sender: UIButton) {
        for control in controls + bottomControlArray.flatMap({ $0 }) where sender.tag == control.tag {
            if sender.tag > 8 && sender.tag < 99 {
                var title: String = ""
                switch control {
                case .custom(let string, _):
                    title = string
                default:
                    break
                }
                if title == sender.titleLabel?.text {
                    delegate?.bottomControlViewActionPerformed(action: control)
                }
            } else {
                delegate?.bottomControlViewActionPerformed(action: control)
            }
        }
    }
}
