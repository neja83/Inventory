//
//  GameScene.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 21.07.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    
    private var lastUpdateTime : TimeInterval = 0
     
    override func sceneDidLoad() {
        
    }
     
    override func didMove(to view: SKView) {
        let itemSize = CGSize(width: 48, height: 48)

        if let v = self.view {

            // Items
            let sword  = Item(id: 1, size: itemSize, name: "sword")
            let shield = Item(id: 2, size: itemSize, name: "shield")
            let knife  = Item(id: 3, size: itemSize, name: "knife")

            // Init inventory

            let items = [sword, shield, knife]

            let config = InventoryConfiguration()
            
            let inventory = Inventory(view: v, configuration: config)
            inventory.save(items: items)
            addChild(inventory)
            inventory.position = CGPoint(x: 0, y: 0)
            
            // Next gen
            
            let anotherNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 2)
            anotherNode.strokeColor = .cyan
            anotherNode.position = CGPoint(x: 0 , y: 200)
            addChild(anotherNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("parent scene") //TODO how send event to children ???
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
