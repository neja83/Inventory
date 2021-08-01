//
//  ColorComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 30.07.2021.
//

import Foundation
import GameplayKit

class ColorComponent: GKComponent {
    
    let color: UIColor
    private var oldColor: UIColor = .clear
    
    init(color: UIColor) {
        self.color = color
        
        super.init()
    }
    
    override func didAddToEntity() {
        if let node = entity?.component(ofType: VisualComponent.self)?.node {
            self.oldColor = node.strokeColor
            node.strokeColor = self.color
        }
    }
    
    override func willRemoveFromEntity() {
        if let node =  entity?.component(ofType: VisualComponent.self)?.node {
            node.strokeColor = self.oldColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
