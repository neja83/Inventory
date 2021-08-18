//
//  Cell.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 23.07.2021.
//

import Foundation
import GameplayKit
import SpriteKit

protocol ExternalPosition {
    var outerPosition: CGPoint { get set }
}

class Cell: SKSpriteNode, ExternalPosition {
    
    var component:  GKComponent?
    
    // MARK: - body
    private var visualNode: SKShapeNode
    
    // MARK: - colors
    private let colorWithItem:    UIColor = .red
    private let colorWithoutItem: UIColor = .blue
    
    private let colorSelected:    UIColor = .yellow
    private let colorCanDrop:     UIColor = .green
    
    private var lastPosition: CGPoint = .zero
    
    var outerPosition: CGPoint = .zero {
        didSet {
            if let frame = self.parent?.parent {
                
                let frameSize = frame.frame.size
                let selfSize = self.frame.size
                let delta = EInventorySetting.scrollMaskPadding
                
                let range = (-frameSize.width/2-selfSize.width + delta...frameSize.width/2 + selfSize.width - delta)

                switch lastPosition.x > outerPosition.x  {
                    case  true: // <---
                        if range.contains(outerPosition.x + position.x - selfSize.width/2) {
                            self.isHidden = false
                        } else {
                            self.isHidden = true
                        }
                    case false: // --->
                        if range.contains(outerPosition.x + position.x + selfSize.width/2) {
                            self.isHidden = false
                        } else {
                            self.isHidden = true
                        }
                }
            }
        }
    }
    
    // MARK: - link with stored item
    private(set) var item: Item? {
        didSet {
            if (item == nil) {
                visualNode.strokeColor = colorWithoutItem
                isEmpty = true
            } else {
                visualNode.strokeColor = colorWithItem
                isEmpty = false
            }
            visualNode.fillColor = .clear
        }
    }
    private(set) var type: CellType
    
    // TODO private and getter for this
    var isEmpty:  Bool = true
    var isSelect: Bool = false {
        didSet {
            visualNode.fillColor = isSelect ? colorSelected : .clear
        }
    }
    var isHover:  Bool = false {
        didSet {
            visualNode.fillColor = isHover ? colorCanDrop : .clear
        }
    }
    
    init(size: CGSize, radius: CGFloat, type: CellType, index: Int) {
        visualNode = SKShapeNode(rectOf: size, cornerRadius: radius)
        self.type = type
        super.init(texture: nil, color: .clear, size: size)
        
        self.name = "Cell \(index)"
        self.visualNode.strokeColor = colorWithoutItem
        self.addChild(visualNode)
    }
    // MARK: - item
    func link(with item: Item) {
        self.item = item
    }
    
    func unLink() {
        self.item = nil
    }
    
    // MARK: - Cell
    func onSelect() {
        isSelect.toggle()
    }
    
    func onHover() {
        isHover.toggle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Cell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let selfItem = self.item {
            if let parentComponent = self.component {
                if let moveSystem = parentComponent.entity?.component(ofType: BackgroundMeshComponent.self) {
                    if moveSystem.fromCell == nil {
                        moveSystem.setFrom(cell: self)
                        self.onSelect()
                    }
                    if (self.type == .outer) {
                        if let background = parentComponent.entity?.component(ofType: BackgroundMeshComponent.self) {
                            let backPosition = background.node.position
                            let selfPosition = self.position
                            let itemPosition = CGPoint(x: selfPosition.x - backPosition.x, y: selfPosition.y - backPosition.y)
                                
                            selfItem.removeFromParent()
                            background.node.addChild(selfItem)
                            selfItem.position = itemPosition
                            
                            
                            if let locker = parentComponent.entity?.component(ofType: LockComponent.self) {
                                locker.lock()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let parentComponent = self.component {
            if let moveSystem = parentComponent.entity?.component(ofType: BackgroundMeshComponent.self) {
                if let fromCell = moveSystem.fromCell {
                    if let toCell = moveSystem.toCell {
                        // Not go back
                        if !fromCell.isEqual(to: self) {
                            if !toCell.isEqual(to: self) {
                                toCell.onHover()
                                if !self.isSelect {
                                    self.onHover()
                                }
                                moveSystem.setTo(cell: self)
                            }
                        } else {
                            toCell.onHover()
                            moveSystem.setTo(cell: nil)
                        }
                    } else {
                        // First cell
                        if !self.isEqual(to: fromCell) {
                            self.onHover()
                            moveSystem.setTo(cell: self)
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isSelect {
            self.onSelect()
        }
    }
}

enum CellType: String {
    case inner
    case outer
}
