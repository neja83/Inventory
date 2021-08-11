//
//  BackgroundMeshComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 10.08.2021.
//

import Foundation
import GameplayKit

class BackgroundMeshComponent: GKComponent {
    
    let node: BackgroundNode
    private var mesh: Mesh?
    
    init(size: CGSize) {
        self.node = BackgroundNode(size: size)
        super.init()
    }
    
    override func didAddToEntity() {
        if let visual = entity?.component(ofType: VisualComponent.self) {
            visual.node.addChild(self.node)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
