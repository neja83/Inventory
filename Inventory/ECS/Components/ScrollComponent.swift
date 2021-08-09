//
//  ScrollComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 07.08.2021.
//

import Foundation
import GameplayKit

class ScrollComponent: GKComponent {
    
    var scroll: NewScrollNode?
    
    override init() {
        super.init()
    }
    
    override func didAddToEntity() {
        if let visual = entity?.component(ofType: VisualComponent.self), let mesh = entity?.component(ofType: MeshComponent.self) {
            let scrollNode = NewScrollNode(size: visual.node.frame.size, background: mesh.background)
            
            self.scroll = scrollNode
            visual.node.addChild(scrollNode)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
