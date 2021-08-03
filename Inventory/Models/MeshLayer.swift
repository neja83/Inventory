//
//  MovedItem.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 27.07.2021.
//

import Foundation
import SpriteKit

protocol MeshLayerPresenter {
    func addElement(element: Item)
}

class MeshLayer: SKShapeNode, MeshLayerPresenter {
    
    // Delegate
    internal let storage: Storage = Storage.share
    
    internal let configuration: InventoryConfiguration
    
    // MARK: - movement
    internal var fromCell: Cell? = nil
    internal var toCell: Cell? = nil
    
    private var boxSize: CGSize {
        self.parent?.frame.size ?? self.calculateAccumulatedFrame().size
    }
    
    private var selfSize: CGSize {
        self.calculateAccumulatedFrame().size
    }
    
    init(configuration: InventoryConfiguration) {
        self.configuration = configuration
        super.init()
     
        let rect = CGRect(origin: CGPoint(x: -configuration.inventoryPointsSize.width/2, y: -configuration.inventoryPointsSize.height/2), size: configuration.inventoryPointsSize)
        self.path = CGPath(rect: rect, transform: .none)
        
        self.strokeColor = .clear
        
        isUserInteractionEnabled = true
        self.storage.presenter = self
    }
    
    // Cells
    public func create() {
        // Self Z position
        if let parentNode = self.parent {
            self.zPosition = parentNode.zPosition + 5
        }
        
        // Up left corner Y coordinate of column
        var positionY: CGFloat = boxSize.height / 2 - configuration.padding
        
        // Lines
        for _ in 1...configuration.inventorySize.lines {
            // Up left corner X coordinate of line
            var positionX: CGFloat = -self.boxSize.width / 2 + configuration.padding
            let diffY = positionY - configuration.cellSize.height / 2
            
            // Columns
            for _ in 1...configuration.inventorySize.columns {
                let diffX = positionX + configuration.cellSize.width / 2
                
                self.addCell(in: CGPoint(x: diffX, y: diffY))
                
                positionX = positionX + configuration.cellSize.width + configuration.padding
            }
            positionY = positionY - configuration.cellSize.height - configuration.padding
        }
    }
    
    private func addCell(in position: CGPoint) {
        let cell = Cell(size: configuration.cellSize, radius: configuration.padding * 2, type: .Inner, index: 1)
        
        cell.position = CGPoint(x: position.x, y: position.y)
        cell.zPosition = self.zPosition + 5
        
        self.addChild(cell)
        self.storage.add(cell: cell)
    }
    
    // Items
    func addElement(element: Item) {
        addChild(element)
    }
    
    // MARK: - Animation actions
    func moveLayer(_ action: SKAction) {
        self.run(action){
            let left  = -self.boxSize.width/2-self.selfSize.width
            let right = self.boxSize.width/2+self.selfSize.width
            self.isHidden = !(left...right).contains(self.position.x)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
