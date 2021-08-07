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
    
    private var childNode: SKShapeNode?
     
    override func sceneDidLoad() {
        manager.scene = self
    }
    
    override func didMove(to view: SKView) {

        let node = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 2)
        node.strokeColor = .blue
        node.fillColor = .green

        let scrollNode = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height/2), cornerRadius: 5)
        scrollNode.fillColor = .clear
        scrollNode.strokeColor = .orange
        scrollNode.addChild(node)
        
        let maskNode = SKShapeNode(rectOf: CGSize(width: size.width/2, height: size.height/2), cornerRadius: 5)
        maskNode.position = CGPoint(x: 0, y: 0)
        maskNode.fillColor = .green
        maskNode.strokeColor = .green

        let scroll: ScrollNode = ScrollNode(mask: maskNode, target: scrollNode)
        scroll.position = CGPoint(x: 0, y: 0)
        addChild(scroll)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.location(in: self)
        
        let nodes = self.nodes(at: position)
        
        for node in nodes {
            node.touchesBegan(touches, with: event)
            if let inv = manager.findEntity(with: node) {
                if let controlPanel = inv.component(ofType: ControlPanelComponent.self) {
                    controlPanel.onClick()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.location(in: self)
        childNode?.position.x = position.x
        let nodes = self.nodes(at: position)
        
        for node in nodes {
            
            node.touchesMoved(touches, with: event)
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
