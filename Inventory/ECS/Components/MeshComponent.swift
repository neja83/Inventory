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
    
    private var background: MeshBackground
    
    init(size: CGSize) {
        self.background = MeshBackground(size: size)
        super.init()
        
        self.background.mesh = self
    }
    
    // MARK: - Override
    override func didAddToEntity() {
        if let visualNode = entity?.component(ofType: VisualComponent.self)?.node {
            self.setup()
            visualNode.addChild(background)
        }
    }
    
    public func add(item: Item) {
        if let first = mesh.first(where: { $0.isEmpty }) {
            first.link(with: item)
            
            item.position = first.position
            item.zPosition = first.zPosition + 5
            background.addChild(item)
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
            
            item.position = cell.position
            item.zPosition = cell.zPosition + 5
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
    
    private func setup() {
        let cellSize = self.calculateCellSize(for: background.calculateAccumulatedFrame().size)
        
        self.create(for: cellSize)
    }
    
    private func create(for cellSize: CGSize) {
        let backgroundSize = background.calculateAccumulatedFrame().size
        let mesh = EInventorySetting.cellNumbers
        var index = 0
        
        // Up left corner Y coordinate of column
        var positionY: CGFloat = backgroundSize.height / 2 // - configuration.padding
        
        // Lines
        for _ in 1...mesh.lines {
            // Up left corner X coordinate of line
            var positionX: CGFloat = -backgroundSize.width / 2 // + configuration.padding
            let diffY = positionY - cellSize.height / 2
            
            // Columns
            for _ in 1...mesh.columns {
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
       CGSize(width: size.width / CGFloat(EInventorySetting.cellNumbers.columns),
              height: size.height / CGFloat(EInventorySetting.cellNumbers.lines))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
