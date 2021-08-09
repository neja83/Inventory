//
//  EEnventory.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 29.07.2021.
//

import Foundation
import GameplayKit

class EInventory: GKEntity {
    
    init(defaultSize: InventorySize) {
        super.init()
        
        let realSize = calculateRealSize(for: defaultSize)
        
        // Components
        let visulComponent = VisualComponent( size: realSize, radius: EInventorySetting.radius,color: EInventorySetting.bodyColor)
        let meshComponent  = MeshComponent(inventorySize: defaultSize)
        let scrollComponent = ScrollComponent()
        let storage = StorageInventoryComponent(items: nil)
        let controlPanel = ControlPanelComponent(size: CGSize(width: 60, height: 30))
        
        // Regestry of components
        self.addComponent(visulComponent)
        self.addComponent(meshComponent)
        self.addComponent(scrollComponent)
        self.addComponent(storage)
        self.addComponent(controlPanel)
        
        // Component settings
        controlPanel.action = meshComponent.sort
    }
    
    func calculateRealSize(for size: InventorySize) -> CGSize {
        let itemSize = EInventorySetting.itemSize
        let columns =  size.columns <= EInventorySetting.maxMeshSize.columns ? size.columns : EInventorySetting.maxMeshSize.columns
        let lines = size.lines <= EInventorySetting.maxMeshSize.lines ? size.lines : EInventorySetting.maxMeshSize.lines
        
        let width = CGFloat(columns) * itemSize.width + EInventorySetting.padding * CGFloat((columns + 1))
        let height = CGFloat(lines) * itemSize.width + EInventorySetting.padding * CGFloat((lines + 1))
        
        return CGSize(width: width, height: height)
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
    static let itemSize: CGSize = CGSize(width: 50, height: 50)
    static let meshSize: InventorySize = InventorySize(lines: 3, columns: 3)
    static let maxMeshSize: InventorySize = InventorySize(lines: 3, columns: 3)
    static let padding: CGFloat = 0
    static let scrollMaskPadding: CGFloat = 5
}

