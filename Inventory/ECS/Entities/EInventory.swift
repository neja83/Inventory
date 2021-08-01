//
//  EEnventory.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 29.07.2021.
//

import Foundation
import GameplayKit

class EInventory: GKEntity {
    
    // Settings
    private let radius: CGFloat = 5
    private let bodyColor: UIColor = .orange
    
    init(size: CGSize) {
        super.init()
        
        // Components
        let visulComponent = VisualComponent(size: size, radius: radius, color: bodyColor)
        let meshComponent  = MeshComponent()
        
        
        // Regestry of components
        self.addComponent(visulComponent)
        self.addComponent(meshComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
