//
//  MeshBackgroundComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 02.08.2021.
//

import Foundation
import GameplayKit

class MeshBackground: SKShapeNode {
    
    internal var mesh: Mesh?
    private var fromCell: Cell?
    private var toCell: Cell?
    
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
    
}

extension MeshBackground {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, touches.count == 1 {
            
            // Position of touch
            let position = touch.location(in: self)
            
            // Collections of nodes at position
            let tochesNodes = self.nodes(at: position)
            
            // Try find cell with item
            for node in tochesNodes.reversed() {
                
                if let cell = node as? Cell {
                    
                    if (!cell.isEmpty) {
                        cell.onSelect()
                        
                        self.fromCell = cell
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touches.count == 1, let movedCell = self.fromCell else { return }
        
        // Position of touch
        let position = touch.location(in: self)
        movedCell.item?.position = position
        
        // Try find cell
        for node in nodes(at: position).reversed() {
            
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
            mesh?.move(from: oldCell, to: newCell)
        } else {
            oldCell.item?.position = oldCell.position
        }
        
        mesh?.dropHoverCell()
        mesh?.dropSelectCell()
        self.fromCell = nil
        self.toCell   = nil
    }
}
