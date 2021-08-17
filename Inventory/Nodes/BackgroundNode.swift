//
//  MeshBackgroundComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 02.08.2021.
//

import Foundation
import GameplayKit

class BackgroundNode: SKShapeNode {
    
    var component: BackgroundMeshComponent?
    var disabled: Bool = false
    private var fromCell: Cell?
    private var toCell: Cell?
    
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
        
        self.strokeColor = .clear
        self.name = "Mesh background node"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BackgroundNode {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first, touches.count == 1 {
            
            // Position of touch
            let position = touch.location(in: self)
            
            // Collections of nodes at position
            let tochesNodes = self.nodes(at: position)
            
            // Try find cell with item
            for node in tochesNodes {
                node.touchesMoved(touches, with: event)
                if let cell = node as? Cell {
                    
                    if (!cell.isEmpty) {
                        
                        if let item = cell.item {
                            item.removeFromParent()
                            item.position = position
                            item.zPosition = EInventorySetting.thirdLayer
                            addChild(item)
                            
                            // Lock scroll component
                            scrollEventsLock()
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Position of touch
        let position = touch.location(in: self)
        
        guard touches.count == 1, let movedCell = self.component?.fromCell else { return }
        
        // Set position for moved item
        movedCell.item?.position = position
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let _ = self.component?.toCell {
            self.component?.setNeedMove(true)
        } else {
            self.component?.rollBack()
        }
        
        clearBackround()
        scrollEventsUnLock()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.component?.rollBack()
        
        clearBackround()
        scrollEventsUnLock()
    }
    
    private func scrollEventsLock() {
        if let parentComponent = self.component {
            if let locker = parentComponent.entity?.component(ofType: LockComponent.self) {
                locker.lock()
            }
        }
    }
    
    private func scrollEventsUnLock() {
        if let parentComponent = self.component {
            if let locker = parentComponent.entity?.component(ofType: LockComponent.self) {
                locker.unLock()
            }
        }
    }
    
    private func clearBackround() {
        if let parentComponent = self.component {
            if let meshComponent = parentComponent.entity?.component(ofType: MeshComponent.self) {
                meshComponent.dropHoverCell()
            }
        }
    }
}
