//
//  Inventory.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 22.07.2021.
//

import Foundation
import SpriteKit

class Inventory: SKSpriteNode  {
    
    // MARK: - size
    private var inventorySize : InventorySize = InventorySize(lines: 3, columns: 3)
    private let cellSize: CGSize = CGSize(width: 52, height: 52)
    private let padding:  CGFloat = 6
    
    // MARK: - storage
    internal var storage: Storage = Storage.share
    
    // TODO: - texture's
    private let defaultIventoryColor: UIColor = .gray
    private let cellDefaultColor: UIColor = .blue
    
    // MARK: - Init
    init(view: SKView, size: InventorySize?) {
                
        // Calculate inventory size
        if let newSize = size {
            self.inventorySize = newSize
        }
        let width  = cellSize.width  * CGFloat(inventorySize.columns) + (CGFloat(inventorySize.columns - 1) * padding)
        let height = cellSize.height * CGFloat(inventorySize.lines)   + (CGFloat(inventorySize.lines - 1)   * padding)
        
        super.init(texture: nil, color: defaultIventoryColor, size: CGSize(width: width, height: height))
        
        self.storage.setup(size: CGSize(width: width, height: height), parent: self)
        self.setupInventory()
        self.setupGestures(view: view)
    }
    
    // MARK: - methods
    func save(items: [Item]) {
        storage.put(items: items)
    }
    
    // MARK: - setups
    private func setupGestures(view: SKView) {
        // Left gesture
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Inventory.swipedHandler))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 2
        
        // Right gesture
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Inventory.swipedHandler))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 2

        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    private func setupInventory() {
        var positionY: CGFloat = self.size.height / 2
        
        // Lines
        for _ in 1...inventorySize.lines {
            var positionX: CGFloat = -self.size.width / 2
            let diffY = positionY - cellSize.height / 2
            
            // Columns
            for _ in 1...inventorySize.columns {
                let diffX = positionX + cellSize.width / 2
                
                self.addCell(in: CGPoint(x: diffX, y: diffY))
                
                positionX = positionX + cellSize.width + padding
            }
            positionY = positionY - cellSize.height - padding
        }
    }
    
    @objc private func swipedHandler(sender: UISwipeGestureRecognizer) {
        
        guard let background = self.storage.backgroundNode, storage.backgroundNode?.fromCell == nil else { return }
        
        var newPosition: CGPoint
        var action: SKAction
        
        switch sender.direction {
            case .left:
                newPosition = CGPoint(x: background.position.x - 100, y: background.position.y)
                action = SKAction.move(to: newPosition, duration: 0.2)
                background.moveItem(action)
            case .right:
                newPosition = CGPoint(x: background.position.x + 100 , y: background.position.y)
                action = SKAction.move(to: newPosition, duration: 0.2)
                background.moveItem(action)
            default:
                print("un support direction")
        }
    }
    
    private func addCell(in position: CGPoint) {
        
        #warning("maybe need refactor")
        let cell = Cell(size: cellSize, radius: padding * 2)
        cell.position = CGPoint(x: position.x, y: position.y)
        cell.zPosition = self.zPosition + 5
        
        self.storage.add(cell: cell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct InventorySize {
    var lines: Int
    var columns: Int
}
