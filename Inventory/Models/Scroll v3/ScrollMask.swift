//
//  ScrollMask.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 08.08.2021.
//

import Foundation
import SpriteKit

class ScrollMasck: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        
        let rect = CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size)
        self.path = CGPath(rect: rect, transform: .none)
        
        self.strokeColor = .blue
        self.fillColor = .blue
        self.zPosition = 10
        
        self.name = "Mask node"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
