//
//  Item.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 23.07.2021.
//

import Foundation
import SpriteKit

class Item: SKSpriteNode {
    
    var id: Int
    
    // MARK: - Default settings
    private let defaulColor: UIColor = .orange
    
    init(id: Int, size: CGSize, name: String) {
        self.id = id
        
        super.init(texture: nil, color: defaulColor, size: size)
        self.name = name
        
        // Temp
        let label = SKLabelNode(text: name)
        label.fontColor = .black
        label.fontSize = 20
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
