//
//  InventoryTouches.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 25.07.2021.
//

import Foundation
import SpriteKit

extension MeshLayer {
    
    // First tap on cell
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, touches.count == 1 {
            
            // Position of touch
            let position = touch.location(in: self)
            
            // Collections of nodes at position
            let tochesNodes = self.nodes(at: position)
            
            // Try find cell with item
            for node in tochesNodes.reversed() {
                
                if let cell = node as? Cell {
                    
                    self.storage.dropSelectCell()
                    if (!cell.isEmpty) {
                        cell.onSelect()
                        
                        //  Select item
                        self.fromCell = cell
                    }
                }
            }
        }
    }
    
    // Moving item
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first, touches.count == 1, let movingItem = self.fromCell?.item else { return }
        
        // Position on touch
        let position = touch.location(in: self)
        
        movingItem.position = position
        
        let toucheNodes = self.nodes(at: position)
        
        for node in toucheNodes.reversed() {
            
            if let cell = node as? Cell {
                if let targetCell = self.toCell {
                    
                    if !(targetCell.isEqual(to: cell)) {
                        
                        storage.dropHoverCell()
                        cell.onHover()
                        self.toCell = cell
                    }
                    
                } else {
                    self.toCell = cell
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let startCell = self.fromCell  else { return }
        
        if let targetCell = self.toCell {
            storage.move(from: startCell, to: targetCell)
        } else {
            // Move item to start position
            startCell.item?.position = startCell.position
        }
        
        // Drop selected and target cell's
        storage.dropSelectCell()
        self.fromCell = nil
        self.toCell = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let startCell = self.fromCell {
            startCell.item?.position = startCell.position
        }
        
        storage.dropHoverCell()
        storage.dropSelectCell()
        self.fromCell = nil
        self.toCell = nil
    }
}
