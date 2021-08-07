//
//  ScrollNode.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 04.08.2021.
//

import Foundation
import SpriteKit

class ScrollNode: SKCropNode {
    
    var scrollNode: SKShapeNode
    var lastPosition: CGPoint?
    
    init(mask: SKShapeNode, target: SKShapeNode) {
        scrollNode = target
        super.init()
        
        maskNode = mask
        
        if let maskNodeSize =  self.maskNode?.calculateAccumulatedFrame() {
            let scrollNodeSize = scrollNode.calculateAccumulatedFrame()
            
            scrollNode.position = CGPoint(x: (scrollNodeSize.width - maskNodeSize.width)/2, y: 0)
            self.addChild(scrollNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ScrollNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        self.lastPosition = touch.location(in: self)
        
        let nodes = self.nodes(at: touch.location(in: self))
        for node in nodes {
            node.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let positionBefor = self.lastPosition else { return }
        
        let position = touch.location(in: self)
        
        self.calculateNewPosition(for: position, after: positionBefor)
        
        let nodes = self.nodes(at: position)
        for node in nodes {
            node.touchesBegan(touches, with: event)
        }
        
        self.lastPosition = position
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
            
        let nodes = self.nodes(at: touch.location(in: self))
        for node in nodes {
            node.touchesBegan(touches, with: event)
        }
        
        self.lastPosition = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
            
        let nodes = self.nodes(at: touch.location(in: self))
        for node in nodes {
            node.touchesBegan(touches, with: event)
        }
        
        self.lastPosition = nil
    }
    
    private func calculateNewPosition(for position: CGPoint, after positionBefor: CGPoint) {
        if let maskNodeSize = maskNode?.calculateAccumulatedFrame() {
            
            let scrollNodeSize = scrollNode.calculateAccumulatedFrame()
            
            switch positionBefor.x > position.x {
                case true: // <--
                    if (-(scrollNodeSize.width-maskNodeSize.width)/2 < self.scrollNode.position.x) {
                        self.scrollNode.position.x = self.scrollNode.position.x - 5
                    }
                case false: // -->
                    if ((scrollNodeSize.width-maskNodeSize.width)/2 > self.scrollNode.position.x) {
                        self.scrollNode.position.x = self.scrollNode.position.x + 5
                    }
            }
        }
    }
}
