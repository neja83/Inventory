//
//  GameScene.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 21.07.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let manager: EntityManager = EntityManager()
    private var lastUpdateTime : TimeInterval = 0
    
     
    override func sceneDidLoad() { manager.scene = self }
    
    override func didMove(to view: SKView) {
        let inventory = EInventory(defaultSize: InventorySize(lines: 3, columns: 5))
        manager.add(entity: inventory)
        
        if let storage = inventory.component(ofType: StorageInventoryComponent.self) {
            let sword = Item(id: 2, size: EInventorySetting.itemSize, name: "Sword")
            let shield = Item(id: 3, size: EInventorySetting.itemSize, name: "Shield")
            
            storage.add(items: [sword, shield])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.location(in: self)
        
        let nodes = self.nodes(at: position)
        
        for node in nodes {
            node.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let nodes = self.nodes(at: touch.location(in: self))
        for node in nodes {
            node.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let nodes = self.nodes(at: touch.location(in: self))
        for node in nodes {
            node.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let nodes = self.nodes(at: touch.location(in: self))
        for node in nodes {
            node.touchesCancelled(touches, with: event)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update systems
        manager.update(dt: dt)
        
        self.lastUpdateTime = currentTime
    }
}
