//
//  ControlPanelComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 03.08.2021.
//

import Foundation
import GameplayKit

protocol AcrionsComponent {
    func onClick()
}

class ControlPanelComponent: GKComponent, AcrionsComponent {
    
    typealias Sort = (() -> Void)
    
    public var button: SKShapeNode
    private var position: ControlPanelPosition
    
    public var action: Sort?
    
    init(size: CGSize, position: ControlPanelPosition = .TOP) {
        self.button = SKShapeNode(rectOf: size, cornerRadius: EInventorySetting.radius)
        self.button.name = "Control panel"
        self.button.fillColor = .green
        self.position = position
        super.init()
    }
    
    override func didAddToEntity() {
        if let node = entity?.component(ofType: VisualComponent.self)?.node {
            let nodeSize = node.calculateAccumulatedFrame()
            let selfSize = button.calculateAccumulatedFrame()
            
            var panelPosition: CGPoint = CGPoint(x: 0, y: 0)
            
            switch self.position {
            case .LEFT:   print("")
            case .RIGHT:  print("")
            case .BOTTON: print("")
            default:
                panelPosition = CGPoint(x: 0, y: (nodeSize.height / 2) + selfSize.height / 2 + 4 )
            }
            
            button.position = panelPosition
            button.zPosition = node.zPosition + 5
            node.addChild(button)
        }
    }
    
    public func onClick() {
        if let complition = self.action {
            complition()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ControlPanelPosition: String {
    case LEFT
    case RIGHT
    case TOP
    case BOTTON
}
