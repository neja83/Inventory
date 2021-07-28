//
//  MovedItem.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 27.07.2021.
//

import Foundation
import SpriteKit

class BackgroundNode: SKShapeNode {
    
    // Delegate
    internal let storage: Storage = Storage.share
    
    // MARK: - movement
    internal var fromCell: Cell? = nil
    internal var toCell: Cell? = nil
    
    private var boxSize: CGSize {
        self.parent?.frame.size ?? self.calculateAccumulatedFrame().size
    }
    
    private var selfSize: CGSize {
        self.calculateAccumulatedFrame().size
    }
    
    init(size: CGSize) {
        super.init()
        
        let rect = CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size)
        self.path = CGPath(rect: rect, transform: .none)
        
        self.strokeColor = .clear
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveItem(_ action: SKAction) {
        self.run(action){
            let left  = -self.boxSize.width/2-self.selfSize.width
            let right = self.boxSize.width/2+self.selfSize.width
            self.isHidden = !(left...right).contains(self.position.x)
        }
    }
}
