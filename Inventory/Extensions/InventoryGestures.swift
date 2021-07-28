//
//  InventoryGestures.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 28.07.2021.
//

import Foundation
import SpriteKit

extension Inventory {
    
    // MARK: - Setup gestures
    internal func setupGestures(view: SKView) {
        
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
    
    // MARK: - Gesture actions handler
    @objc internal func swipedHandler(sender: UISwipeGestureRecognizer) {
        
        guard self.mesh.fromCell == nil else { return }
        
        var newPosition: CGPoint
        var action: SKAction
        
        let delta = self.configuration.cellSize.width + self.configuration.padding
        
        switch sender.direction {
            case .left:
                newPosition = CGPoint(x: self.mesh.position.x - delta, y: self.mesh.position.y)
                action = SKAction.move(to: newPosition, duration: 0.2)
                self.mesh.moveLayer(action)
            case .right:
                newPosition = CGPoint(x: self.mesh.position.x + delta , y: self.mesh.position.y)
                action = SKAction.move(to: newPosition, duration: 0.2)
                self.mesh.moveLayer(action)
            default:
                print("un support direction")
        }
    }
}
