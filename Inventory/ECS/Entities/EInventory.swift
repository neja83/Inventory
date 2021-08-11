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
        
        // Calculate size in points
        let frameSize = calculateFrameSize(for: defaultSize)
        let realSize = calculateRealSize(for: defaultSize)
        
        // Components
        let visulComponent = VisualComponent( size: frameSize, radius: EInventorySetting.radius,color: EInventorySetting.bodyColor)
        let backgroundMeshComponent = BackgroundMeshComponent(size: realSize)
        let meshComponent    = MeshComponent(size: defaultSize)
        let storageComponent = StorageInventoryComponent()
        let scrollComponent  = ScrollComponent()
        
        // Regestry of components
        self.addComponent(visulComponent)
        self.addComponent(backgroundMeshComponent)
        self.addComponent(meshComponent)
        self.addComponent(storageComponent)
        self.addComponent(scrollComponent)
    }
    
    private func calculateFrameSize(for size: InventorySize) -> CGSize {
        let itemSize = EInventorySetting.itemSize
        let columns =  size.columns <= EInventorySetting.maxMeshSize.columns ? size.columns : EInventorySetting.maxMeshSize.columns
        let lines = size.lines <= EInventorySetting.maxMeshSize.lines ? size.lines : EInventorySetting.maxMeshSize.lines
        
        let width = CGFloat(columns) * itemSize.width + EInventorySetting.padding * CGFloat((columns + 1))
        let height = CGFloat(lines) * itemSize.height + EInventorySetting.padding * CGFloat((lines + 1))
        
        return CGSize(width: width, height: height)
    }
    
    private func calculateRealSize(for size: InventorySize) -> CGSize {
        let itemSize = EInventorySetting.itemSize
        
        let width = CGFloat(size.columns) * itemSize.width + EInventorySetting.padding * CGFloat((size.columns + 1))
        let height = CGFloat(size.lines) * itemSize.height + EInventorySetting.padding * CGFloat((size.lines + 1))
        
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
