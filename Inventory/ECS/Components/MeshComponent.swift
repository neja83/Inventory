//
//  MeshComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 30.07.2021.
//

import Foundation
import GameplayKit

protocol Mesh {
    func add(item: Item)
    func move(from firstCell: Cell, to secondCell: Cell)
    func dropHoverCell()
    func dropSelectCell()
}

class MeshComponent: GKComponent, Mesh {
    
    var mesh: [Cell] = []
    var background: MeshBackground
    
    private var meshSize: InventorySize
    
    init(inventorySize: InventorySize) {
        let itemSize = EInventorySetting.itemSize
        
        let width = CGFloat(inventorySize.columns) * itemSize.width + EInventorySetting.padding * CGFloat((inventorySize.columns + 1))
        let height = CGFloat(inventorySize.lines) * itemSize.width + EInventorySetting.padding * CGFloat((inventorySize.lines + 1))
        let size = CGSize(width: width, height: height)
        
        self.background = MeshBackground(size: CGSize(width: size.width, height: size.height))
        self.meshSize = inventorySize
        super.init()
        
        self.background.mesh = self
    }
    
    // MARK: - Override
    override func didAddToEntity() {
        self.setup()
    }
    
    // MARK: - Item actioins
    func add(item: Item) {
        if let first = mesh.first(where: { $0.isEmpty }) {
            first.link(with: item)
            
            item.position = .zero
            first.addChild(item)
        } else {
            
        }
    }
    
    func dropSelectCell() {
        for cell in self.mesh.filter({$0.isSelect}) {
            cell.onSelect()
        }
    }
    
    func dropHoverCell() {
        for cell in self.mesh.filter({ $0.isHover }) {
            cell.onHover()
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
    
    public func sort(){
        self.mesh = self.mesh.sorted { second, first in
            if (first.isEmpty && !second.isEmpty) {
                
                let firstPosition = first.position
                let secondPosition = second.position
                
                first.position = secondPosition
                second.position = firstPosition
                
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
        // TODO sort by item name
    }
    
    // MARK: - Mesh setup
    private func setup() {
        let cellSize = self.calculateCellSize(for: background.calculateAccumulatedFrame().size)
        
        self.create(with: cellSize)
    }
    
    private func create(with cellSize: CGSize) {
        let backgroundSize = background.calculateAccumulatedFrame().size
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
    
    private func addCell(at position: CGPoint, with cellSize: CGSize, index: Int){
        let cell = Cell(size: cellSize, radius: 2, type: .Inner, index: index)
        
        cell.position = CGPoint(x: position.x, y: position.y)
        cell.zPosition = background.zPosition + 5
        
        background.addChild(cell)
        self.mesh.append(cell)
    }
    
    private func calculateCellSize(for size: CGSize) -> CGSize {
       CGSize(width: size.width / CGFloat(meshSize.columns),
              height: size.height / CGFloat(meshSize.lines))
    }
    
    private func calculateBackgroundSize(for size: InventorySize) -> CGSize {
        let itemSize = EInventorySetting.itemSize
        
        let width = CGFloat(size.columns) * itemSize.width + EInventorySetting.padding * CGFloat((size.columns + 1))
        let height = CGFloat(size.lines) * itemSize.width + EInventorySetting.padding * CGFloat((size.lines + 1))
        
        return CGSize(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
