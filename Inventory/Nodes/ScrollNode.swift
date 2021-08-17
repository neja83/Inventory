//
//  NewScrollNode.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 08.08.2021.
//

import Foundation
import GameplayKit

class ScrollNode: SKShapeNode {
    
    let background: BackgroundNode
    let frameSize: CGSize
    var disabled: Bool = false
    private var lastPosition: CGPoint?
    
    init(size: CGSize, background: BackgroundNode) {
        self.background = background 
        frameSize = size
        super.init()
        
        self.selfSetup()
        self.setupMasks()
    
//        addChild(background)
        // Default background position
        self.background.position = CGPoint(x: self.background.frame.size.width/2 - self.frameSize.width/2, y: 0)
        self.zPosition = EInventorySetting.firstLayer
    }
    
    private func selfSetup() {
        let rect = CGRect(origin: CGPoint(x: -frameSize.width/2, y: -frameSize.height/2), size: frameSize)
        self.path = CGPath(rect: rect, transform: .none)
        self.strokeColor = .yellow
        self.name = "Scroll node"
    }
    
    private func setupMasks() {
        
        let leftNodeMask = ScrollMasck(size: CGSize(width: EInventorySetting.itemSize.width, height: frameSize.height))
        leftNodeMask.position = CGPoint(x: -frameSize.width/2-leftNodeMask.frame.width/2, y: 0)
        leftNodeMask.zPosition = EInventorySetting.seconLayer
        
        let rightNodeMask = ScrollMasck(size: CGSize(width: EInventorySetting.itemSize.width, height: frameSize.height))
        rightNodeMask.position = CGPoint(x: frameSize.width/2+rightNodeMask.frame.width/2, y: 0)
        rightNodeMask.zPosition = EInventorySetting.seconLayer
        
        addChild(leftNodeMask)
        addChild(rightNodeMask)
    }
    
    private func calculatePosition(position: CGPoint)  {
        let scrollNodeSize = self.background.frame.size
        
        if let lastPoint = lastPosition {
            switch lastPoint.x > position.x {
                case true: // <---
                    if (-(scrollNodeSize.width-frameSize.width)/2 < self.background.position.x) {
                        self.background.position.x = self.background.position.x - 3
                    }
                case false: // --->
                    if ((scrollNodeSize.width-frameSize.width)/2 > self.background.position.x) {
                        self.background.position.x = self.background.position.x + 3
                    }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScrollNode {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !disabled, let touch = touches.first else { return }
        
        self.lastPosition = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !disabled, let touch = touches.first else { return }
        
        let position = touch.location(in: self)
        
        self.calculatePosition(position: position)
        
        self.lastPosition = position
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastPosition = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastPosition = nil
    }
    
}
