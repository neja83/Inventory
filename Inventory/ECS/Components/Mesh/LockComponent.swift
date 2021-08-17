//
//  LockComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 11.08.2021.
//

import Foundation
import GameplayKit

class LockComponent: GKComponent {
    private(set) var needLock: Bool = false
    private(set) var needUnLock: Bool = false
}

extension LockComponent {
    
    func lock() {
        needLock = true
    }
    
    func unLock() {
        needUnLock = true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard needLock || needUnLock else { return }

        
        if let components = self.entity?.components {
            
            for component in components {
                if let lockComponent = component as? BlockedComponent {
                    lockComponent.setDisabled(needLock)
                }
            }
            
            needLock   = false
            needUnLock = false
        }
    }
    
}
