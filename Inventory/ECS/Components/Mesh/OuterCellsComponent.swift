//
//  OuterCellsComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 12.08.2021.
//

import Foundation
import GameplayKit

class OuterCellsComponent: GKComponent {
    
    private(set) var cells: [Cell] = []
    
    func registry(cell: Cell)  {
        self.cells.append(cell)
        
        if let visual = self.entity?.component(ofType: VisualComponent.self)?.node {
            visual.addChild(cell)
            cell.component = self
        }
    }
    
    func remove(cell: Cell) -> Cell? {
        if let index = self.cells.firstIndex(of: cell) {
            cell.component = nil
            cell.removeFromParent()
            return self.cells.remove(at: index)
        }
        return nil
    }
}
