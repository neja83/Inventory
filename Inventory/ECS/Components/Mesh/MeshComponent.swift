//
//  MeshComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 11.08.2021.
//

import Foundation
import GameplayKit

class MeshComponent: GKComponent {
    
    private var background: BackgroundNode?
    private let inventorySize: InventorySize
    private var mesh: [Cell] = []
    
    init(size: InventorySize) {
        self.inventorySize = size
        super.init()
    }
    
    override func didAddToEntity() {
        if let backgroundMesh = entity?.component(ofType: BackgroundMeshComponent.self) {
            
            self.background = backgroundMesh.node
            self.setup()
        }
    }
    
    public func put(item: Item) {
        let cell = self.getFirstCell()
        cell.link(with: item)
        item.position = .zero
            
        cell.addChild(item)
    }
    
    private func setup() {
        self.create(with: EInventorySetting.itemSize, backgroundSize: self.calculateBackgroundSize(for: self.inventorySize))
    }
    
    private func add(cell: Cell) {
        self.mesh.append(cell)
    }
    
    private func getFirstCell() -> Cell {
        if let freeCell = self.mesh.first(where: {$0.isEmpty}) {
            return freeCell
        }else {
            return addNewCell()
        }
    }
    
    /// ToDo  REFACTORING THIS!
    private func addNewCell() -> Cell {
        Cell(size: CGSize(width: 0, height: 0), radius: 0, type: .inner, index: 555)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MeshComponent {
    
    func dropSelectCell() {
        if let meshOfCell = entity?.component(ofType: MeshComponent.self) {
            for cell in meshOfCell.mesh.filter({$0.isSelect}) {
                cell.onSelect()
            }
        }
    }

    func dropHoverCell() {
        if let meshOfCell = entity?.component(ofType: MeshComponent.self) {
            for cell in meshOfCell.mesh.filter({ $0.isHover }) {
                cell.onHover()
            }
        }
    }
}

extension MeshComponent {
    
    /// Generated mesh
    private func create(with cellSize: CGSize, backgroundSize: CGSize) {
        var index = 0
        
        // Up left corner Y coordinate of column
        var positionY: CGFloat = backgroundSize.height / 2 // - configuration.padding
        
        // Lines
        for _ in 1...inventorySize.lines {
            // Up left corner X coordinate of line
            var positionX: CGFloat = -backgroundSize.width / 2 // + configuration.padding
            let diffY = positionY - cellSize.height / 2
            
            // Columns
            for _ in 1...inventorySize.columns {
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
        guard let backroundMesh = self.background else { return }
        
        let cell = Cell(size: cellSize, radius: 2, type: .inner, index: index)
         
        cell.position = CGPoint(x: position.x, y: position.y)
        cell.zPosition = EInventorySetting.firstLayer
        
        backroundMesh.addChild(cell)
        add(cell: cell)
    }
    
    /// Calculate background size based on *inventorySize*
    private func calculateBackgroundSize(for size: InventorySize) -> CGSize {
        let itemSize = EInventorySetting.itemSize
        
        let width = CGFloat(size.columns) * itemSize.width + EInventorySetting.padding * CGFloat((size.columns + 1))
        let height = CGFloat(size.lines) * itemSize.height + EInventorySetting.padding * CGFloat((size.lines + 1))
        
        return CGSize(width: width, height: height)
    }
}


extension MeshComponent {
    public func sort(){
        self.mesh = self.mesh.sorted { second, first in
            if (first.isEmpty && !second.isEmpty) {
                
                let firstPosition = first.position
                let firstIsHidden = first.isHidden
                let secondPosition = second.position
                let secondIsHidden = second.isHidden
                
                first.position = secondPosition
                first.isHidden = secondIsHidden
                second.position = firstPosition
                second.isHidden = firstIsHidden
                
                return true
            }
            if (!first.isEmpty && second.isEmpty) {
                return false
            }
            if (first.isEmpty && second.isEmpty) {
                return false
            }
            return false
        }
//        for item in mesh {
//            print(item.isHidden)
//        }
        // TODO sort by item name
    }
}
