//
//  MeshComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 30.07.2021.
//

import Foundation
import GameplayKit

class MeshComponent: GKComponent {
    
    var mesh: [Cell] = []
    
    private let cellNumbers: InventorySize = InventorySize(lines: 3, columns: 3)
    
    override init() {
        super.init()
    }
    
    override func didAddToEntity() {
        if let visualNode = entity?.component(ofType: VisualComponent.self)?.node {
            self.add(in: visualNode)
        }
    }
    
    private func add(in node: SKNode) {
        let cellSize = self.calculateCellSize(for: node.calculateAccumulatedFrame().size)
        self.create(for: cellSize, in: node)
    }
    
    private func create(for cellSize: CGSize, in node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame().size
        
        // Up left corner Y coordinate of column
        var positionY: CGFloat = nodeSize.height / 2 // - configuration.padding
        
        // Lines
        for _ in 1...cellNumbers.lines {
            // Up left corner X coordinate of line
            var positionX: CGFloat = -nodeSize.width / 2 // + configuration.padding
            let diffY = positionY - cellSize.height / 2
            
            // Columns
            for _ in 1...cellNumbers.columns {
                let diffX = positionX + cellSize.width / 2
                
                self.addCell(at: CGPoint(x: diffX, y: diffY), with: cellSize, in: node)
                
                positionX = positionX + cellSize.width // + configuration.padding
            }
            positionY = positionY - cellSize.height // - configuration.padding
        }
        
    }
    
    private func addCell(at position: CGPoint, with cellSize: CGSize, in node: SKNode){
        let cell = Cell(size: cellSize, radius: 2, type: .Inner)
        
        cell.position = CGPoint(x: position.x, y: position.y)
        cell.zPosition = node.zPosition + 5
        
        node.addChild(cell)
        self.mesh.append(cell)
    }
    
    private func calculateCellSize(for size: CGSize) -> CGSize {
       CGSize(width: size.width / CGFloat(cellNumbers.columns), height: size.height / CGFloat(cellNumbers.lines))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
