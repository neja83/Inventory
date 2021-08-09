//
//  BackgroundNode.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 08.08.2021.
//

import Foundation
import SpriteKit

class BackgroundNode: SKShapeNode {
    
    override var position: CGPoint {
        didSet {
            for node in self.children  {
                if var item = node as? ExternalPosition {
                    item.outerPosition = position
                }
            }
        }
    }
    
    
    init(size: CGSize) {
        super.init()
        
        let rect = CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size)
        self.path = CGPath(rect: rect, transform: .none)
        self.strokeColor = .green
        self.name = "Background node"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
