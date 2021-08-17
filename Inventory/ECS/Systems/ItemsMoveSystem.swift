//
//  ItemsMoveSystem.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 13.08.2021.
//

import Foundation
import GameplayKit

extension BackgroundMeshComponent {
    
    override func update(deltaTime seconds: TimeInterval) {
        guard self.needMove else { return }
        
        self.setNeedMove(false)
        
        if let oldCell = self.fromCell, let newCell = self.toCell {
            move(from: oldCell, to: newCell)
        }
        self.clearCells()
    }
    
    
    private func move(from firstCell: Cell, to secondCell: Cell ) {

        let firstItem = extract(from: firstCell)
        let secondItem = extract(from: secondCell)

        if let item = firstItem {
            put(item: item, in: secondCell)
        }

        if let item = secondItem {
            put(item: item, in: firstCell)
        }
    }

    private func put(item: Item, in cell: Cell) {
        if (cell.isEmpty) {
            cell.link(with: item)
            item.removeFromParent()

            item.position = .zero
            item.zPosition = EInventorySetting.firstLayer

            cell.addChild(item)
        }
    }

    private func extract(from cell: Cell) -> Item? {
        if let item = cell.item {
            cell.unLink()
            return item
        } else {
            return nil
        }
    }
}
