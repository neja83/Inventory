//
//  BackgroundMeshComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 10.08.2021.
//

import Foundation
import GameplayKit

class BackgroundMeshComponent: GKComponent {
    
    let node: BackgroundNode
    
    private(set) var needMove: Bool = false
    private(set) var fromCell: Cell?
    private(set) var toCell: Cell?
    
    init(size: CGSize) {
        self.node = BackgroundNode(size: size)
        super.init()
        self.node.component = self
    }
    
    override func didAddToEntity() {
        if let visual = entity?.component(ofType: VisualComponent.self) {
            self.node.zPosition = EInventorySetting.zeroLayer
            visual.node.addChild(self.node)
        }
    }
    
    func setNeedMove(_ value: Bool) {
        self.needMove = value
    }
    
    func setFrom(cell: Cell?) {
        self.fromCell = cell
    }
    
    func setTo(cell: Cell?) {
        self.toCell = cell
    }
    
    func rollBack() {
        if let oldCell = self.fromCell {
            if let item = oldCell.item {
                item.removeFromParent()
                oldCell.addChild(item)
                item.position = .zero
                item.zPosition = .zero
            }
            self.fromCell = nil
        }
    }
    
    func clearCells() {
        self.needMove = false
        self.fromCell = nil
        self.toCell   = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
