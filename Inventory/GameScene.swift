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
    
    let systems: [GKComponentSystem<GKComponent>] = {
        var visualComponentObject = GKComponentSystem(componentClass: VisualComponent.self)
        
        return [visualComponentObject]
    }()
    
    private var lastUpdateTime : TimeInterval = 0
     
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
        let inventoryAsEntity = EInventory(size: CGSize(width: 200, height: 100))
        
        for system in systems {
            system.addComponent(foundIn: inventoryAsEntity)
        }
        
        if let component = inventoryAsEntity.component(ofType: VisualComponent.self) {
            self.addChild(component.node)
        }
        
        entities.append(inventoryAsEntity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.location(in: self)
        
        let nodes = self.nodes(at: position)
        
        for node in nodes {
            print(node)
            
            if let inventory = entities.first(
                where: { $0.component(ofType: VisualComponent.self)!.node.isEqual(to: node)}) {
                let colorComponent = ColorComponent(color: .magenta)
                inventory.addComponent(colorComponent)
            }
            
//            if let ent = node as? EInventory {
//                let colorComponent = ColorComponent(color: .magenta)
//                ent.addComponent(colorComponent)
//            }
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
        for sistem in systems {
            sistem.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
