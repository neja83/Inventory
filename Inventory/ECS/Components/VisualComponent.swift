//
//  CellComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 29.07.2021.
//

import Foundation
import GameplayKit

class VisualComponent: GKComponent {
    
    var node: SKShapeNode
    
    init(size: CGSize, radius: CGFloat, color: UIColor) {
        self.node = SKShapeNode(rectOf: size, cornerRadius: radius)
        node.strokeColor = color
        node.name = "Visual node"
    
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        print("Update Component")
    }
}
