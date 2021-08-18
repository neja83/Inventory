//
//  ButtonNode.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 12.08.2021.
//

import Foundation
import SpriteKit

class ButtonNode: SKShapeNode {
    
    var onClick: (() -> Any?)?
    
    init(size: CGSize) {
        super.init()
        
        let rect = CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size)
        self.path = CGPath(rect: rect, transform: .none)
        
        self.name = "Button"
        self.fillColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let action = self.onClick {
            let _ = action()
        }
    }
}
