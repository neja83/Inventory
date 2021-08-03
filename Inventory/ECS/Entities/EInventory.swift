//
//  EEnventory.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 29.07.2021.
//

import Foundation
import GameplayKit

class EInventory: GKEntity {
    
    init(size: CGSize) {
        super.init()
        
        // Components
        let visulComponent = VisualComponent(size: size, radius: EInventorySetting.radius, color: EInventorySetting.bodyColor)
        let meshComponent  = MeshComponent(size: size)
        let storage = StorageInventoryComponent(items: nil)
        let controlPanel = ControlPanelComponent(size: CGSize(width: 60, height: 60))
        
        // Regestry of components
        self.addComponent(visulComponent)
        self.addComponent(meshComponent)
        self.addComponent(storage)
        self.addComponent(controlPanel)
        
        // Component settings
        controlPanel.action = meshComponent.sort
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct EInventorySetting {
    
    // EInventory
    static let radius: CGFloat = 5
    static let bodyColor: UIColor = .orange
    
    // Mesh
    static let cellNumbers: InventorySize = InventorySize(lines: 3, columns: 3)
}

