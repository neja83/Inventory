//
//  MeshBackgroundComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 02.08.2021.
//

import Foundation
import GameplayKit

class BackgroundNode: SKShapeNode {
    
    var meshDelegate: Mesh?
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
                
                if let cell = node as? Cell {
                    
                    if (!cell.isEmpty) {
                        cell.onSelect()
                        
                        self.fromCell = cell
                        if let item = self.fromCell?.item {
                            item.removeFromParent()
                            item.position = position
                            item.zPosition = 10
                            addChild(item)
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
        
        guard touches.count == 1, let movedCell = self.fromCell else { return }
        
        movedCell.item?.position = position
        // Try find cell
        for node in nodes(at: position) {
            
            if let cell = node as? Cell {
    
                if !(cell.isHover) {
                    if let lastToCell = toCell {
                        lastToCell.onHover()
                    }
                    
                    cell.onHover()
                    self.toCell = cell
                }
           
                if let lastToCell = self.toCell, let oldCell = self.fromCell, oldCell.isEqual(to: cell) {
                    lastToCell.onHover()
                    self.toCell = nil
                }
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let oldCell = self.fromCell else { return }
        
        if let newCell = self.toCell {
            meshDelegate?.move(from: oldCell, to: newCell)
        } else {
            if let item = oldCell.item {
                item.removeFromParent()
                oldCell.addChild(item)
                item.position = .zero
            }
        }
        
        meshDelegate?.dropHoverCell()
        meshDelegate?.dropSelectCell()
        self.fromCell = nil
        self.toCell   = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        // TODO - add actions for toCell scenario
        
        if let oldCell = self.fromCell {
            if let item = oldCell.item {
                item.removeFromParent()
                oldCell.addChild(item)
                item.position = .zero
            }
        }
        
        meshDelegate?.dropHoverCell()
        meshDelegate?.dropSelectCell()
        self.fromCell = nil
        self.toCell   = nil
    }
}
