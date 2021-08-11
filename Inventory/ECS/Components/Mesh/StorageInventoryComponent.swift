//
//  StorageInventoryComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 02.08.2021.
//

import Foundation
import GameplayKit


/// Working with Items suchs as "adding", "delete"
class StorageInventoryComponent: GKComponent {
    
    var data: [Item]
    
    private var mesh: MeshComponent?
    
    init(items: [Item] = []) {
        self.data = items
        super.init()
    }
    
    override func didAddToEntity() {
        if let mesh = entity?.component(ofType: MeshComponent.self) {
            self.mesh = mesh
        }
    }
    
    /// Add item on inventory
    /// Use only this method for add new Items in inventory
    func add(items: [Item]) {
        for item in items {
            self.add(item: item)
        }
    }
    
    private func add(item: Item) {
        data.append(item)
        
        mesh?.put(item: item)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
