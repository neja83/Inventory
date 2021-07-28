//
//  Inventory.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 22.07.2021.
//

import Foundation
import SpriteKit

class Inventory: SKSpriteNode  {
    
    // MARK: layers
    internal let storage: Storage = Storage.share
    internal let mesh: MeshLayer
    
    // MARK: - Global setting for inventory
    internal let configuration: InventoryConfiguration
    
    // MARK: - Init
    init(view: SKView, configuration: InventoryConfiguration) {
        self.configuration = configuration
        self.mesh = MeshLayer(configuration: configuration)
        
        super.init(texture: nil, color: InventoryColors.defaultIventoryColor, size: configuration.inventoryPointsSize)
        
        mesh.zPosition = self.zPosition + 5
        self.addChild(self.mesh)
        
//        self.setupGestures(view: view)
        self.initialInventory()
    }
    
    private func initialInventory() {
        self.mesh.create()
    }
    
    func save(items: [Item]) {
        self.storage.put(items: items)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct InventorySize {
    var lines: Int
    var columns: Int
}
