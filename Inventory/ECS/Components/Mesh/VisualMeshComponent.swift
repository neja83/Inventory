//
//  VisualMeshComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 10.08.2021.
//

import Foundation
import GameplayKit

class VisualMeshComponent: GKComponent {
    
    var background: BackgroundNode?
    
    private var meshSize: InventorySize
    
    init(inventorySize: InventorySize) {
        self.meshSize = inventorySize
        super.init()
        
        self.background = BackgroundNode(size: calculateBackgroundSize(for: inventorySize))
        self.background?.meshDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Mesh setup
    func setup() {
        if let meshBackground = self.background, let visual = self.entity?.component(ofType: VisualComponent.self) {
            visual.node.addChild(meshBackground)
            self.create(with: EInventorySetting.itemSize, backgroundSize: meshBackground.frame.size)
        }
    }
    
    /// Generated mesh
    private func create(with cellSize: CGSize, backgroundSize: CGSize) {
        var index = 0
        
        // Up left corner Y coordinate of column
        var positionY: CGFloat = backgroundSize.height / 2 // - configuration.padding
        
        // Lines
        for _ in 1...meshSize.lines {
            // Up left corner X coordinate of line
            var positionX: CGFloat = -backgroundSize.width / 2 // + configuration.padding
            let diffY = positionY - cellSize.height / 2
            
            // Columns
            for _ in 1...meshSize.columns {
                let diffX = positionX + cellSize.width / 2
                
                self.addCell(at: CGPoint(x: diffX, y: diffY), with: cellSize, index: index)
                
                positionX = positionX + cellSize.width // + configuration.padding
                index += 1
            }
            positionY = positionY - cellSize.height // - configuration.padding
        }
        
    }
    
    /// Create cell, added it on background node and in mesh array
    private func addCell(at position: CGPoint, with cellSize: CGSize, index: Int) {
        guard let backroundMesh = self.background, let mesh = entity?.component(ofType: MeshComponentOld.self) else { return }
        
        let cell = Cell(size: cellSize, radius: 2, type: .Inner, index: index)
         
        cell.position = CGPoint(x: position.x, y: position.y)
        cell.zPosition = backroundMesh.zPosition + 5
        
        backroundMesh.addChild(cell)
        mesh.add(cell: cell)
    }
    
    /// Calculate background size based on *inventorySize*
    private func calculateBackgroundSize(for size: InventorySize) -> CGSize {
        let itemSize = EInventorySetting.itemSize
        
        let width = CGFloat(size.columns) * itemSize.width + EInventorySetting.padding * CGFloat((size.columns + 1))
        let height = CGFloat(size.lines) * itemSize.height + EInventorySetting.padding * CGFloat((size.lines + 1))
        
        return CGSize(width: width, height: height)
    }
}

extension VisualMeshComponent: Mesh {
    
    // MARK: - Item actions
    public func show(item: Item, in cell: Cell) {
        item.position = .zero
        cell.addChild(item)
    }
    
    func dropSelectCell() {
        if let meshOfCell = entity?.component(ofType: MeshComponentOld.self) {
            for cell in meshOfCell.mesh.filter({$0.isSelect}) {
                cell.onSelect()
            }
        }
    }

    func dropHoverCell() {
        if let meshOfCell = entity?.component(ofType: MeshComponentOld.self) {
            for cell in meshOfCell.mesh.filter({ $0.isHover }) {
                cell.onHover()
            }
        }
    }

    public func move(from firstCell: Cell, to secondCell: Cell) {

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
            item.zPosition = cell.zPosition + 5

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
