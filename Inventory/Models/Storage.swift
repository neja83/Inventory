//
//  Storage.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 23.07.2021.
//

import Foundation
import SpriteKit

class Storage {
    
    private var data: [Cell] = []
    private let zPositionStep: CGFloat = 5 // TODO take it from plis
    var presenter: MeshLayerPresenter?
    
    private init() {}
    static let share: Storage = {
        let instance = Storage()
        // Some settign's
        return instance
    }()
    
    // MARK: - Cells
    func add(cell: Cell) {
        data.append(cell) 
    }
    
    // MARK: - Items
    func put(item: Item) {
        if let cell = firstFreeCell() {
            cell.link(with: item)
            
            self.presenter?.addElement(element: item)
            item.position = cell.position
            item.zPosition = cell.zPosition + zPositionStep
        }
    }
    
    func put(item: Item, in cell: Cell) {
        if (cell.isEmpty) {
            cell.link(with: item)
            
            item.position = cell.position
            item.zPosition = cell.zPosition + zPositionStep
        }
    }
    
    func put(items: [Item]) {
        for item in items {
            self.put(item: item)
        }
    }
    
    func move(from firstCell: Cell, to secondCell: Cell) {
        
        let firstItem = extract(from: firstCell)
        let secondItem = extract(from: secondCell)
        
        if let item = firstItem {
            put(item: item, in: secondCell)
        }
        
        if let item = secondItem {
            put(item: item, in: firstCell)
        }
    }
    
    #warning("may be it is insecure operation!")
    func extract(from cell: Cell) -> Item? {
        if let item = cell.item {
            cell.unLink()
            return item
        } else {
            return nil
        }
    }
    
    func dropSelectCell() {
        for cell in self.data.filter({$0.isSelect}) {
            cell.onSelect()
        }
    }
    
    func dropHoverCell() {
        for cell in self.data.filter({ $0.isHover }) {
            cell.onHover()
        }
    }
    
    // MARK: - Helpers
    private func firstFreeCell() -> Cell? {
        return self.data.first(where: {$0.isEmpty})
    }
}
