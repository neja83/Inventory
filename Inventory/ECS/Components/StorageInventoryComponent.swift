//
//  StorageInventoryComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 02.08.2021.
//

import Foundation
import GameplayKit

class StorageInventoryComponent: GKComponent {
    
    var data: [Item] = []
    
    private var mesh: MeshComponent?
    
    init(items: [Item]?) {
        if let newData = items {
            self.data = newData
        }
        
        super.init()
    }
    
    override func didAddToEntity() {
        if let mesh = entity?.component(ofType: MeshComponent.self) {
            self.mesh = mesh
        }
    }
    
    func add(item: Item) {
        data.append(item)
        
        mesh?.add(item: item)
    }
    
    func add(items: [Item]) {
        for item in items {
            self.add(item: item)
        }
    }
    
    func delete(item: Item) {
        if let index = data.firstIndex(of: item) {
            data.remove(at: index)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
