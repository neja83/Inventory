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
     
    override func sceneDidLoad() {
        manager.scene = self
    }
    
    override func didMove(to view: SKView) {
        let inventoryAsEntity = EInventory(size: CGSize(width: 200, height: 100))
        
        manager.add(entity: inventoryAsEntity)
        
        if let storage = inventoryAsEntity.component(ofType: StorageInventoryComponent.self) {
            let sword = Item(id: 4, size: CGSize(width: 66, height: 33), name: "Sword")
            let shield = Item(id: 6, size: CGSize(width: 66, height: 33), name: "Shield")
            
            storage.add(items: [sword, shield])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.location(in: self)
        
        let nodes = self.nodes(at: position)
        print("scene")

        for node in nodes {
            if let inv = manager.findEntity(with: node) {
                if let controlPanel = inv.component(ofType: ControlPanelComponent.self) {
                    controlPanel.onClick()
                }
            }
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
