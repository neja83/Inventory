//
//  ItemNode.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 08.08.2021.
//

import Foundation
import SpriteKit

class ItemNode: SKShapeNode, ExternalPosition {
    
    let label: SKLabelNode
    
    var outerPosition: CGPoint = .zero {
        didSet {
            label.text = String("\(Int(outerPosition.x)):\(Int(outerPosition.y))")
            if let back = self.parent?.parent {
                let backSize = back.frame.size
                let selfSize = self.frame.size
                
                switch outerPosition.x > 0 {
                    case true: // --->
                        if (-backSize.width/2...backSize.width/2).contains(outerPosition.x + position.x + selfSize.width/2) {
                            self.isHidden = false
                        } else {
                            self.isHidden = true
                        }
                    case false: // <---
                        if (-backSize.width/2...backSize.width/2).contains(outerPosition.x + position.x - selfSize.width/2) {
                            self.isHidden = false
                        } else {
                            self.isHidden = true
                        }
                }
            }
        }
    }
    
    init(size: CGSize) {
        label = SKLabelNode(text: "0:0")
        super.init()
        
        let rect = CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size)
        self.path = CGPath(rect: rect, transform: .none)
        self.fillColor = .red
        self.name = "Item node"
        
        label.position = CGPoint(x: 0, y: size.height/2 + 10)
        label.fontSize = 20
        
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
