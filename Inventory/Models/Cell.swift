//
//  Cell.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 23.07.2021.
//

import Foundation
import SpriteKit

class Cell: SKSpriteNode {
    
    private var visualNode: SKShapeNode
    
    // MARK: - colors
    private let colorWithItem:    UIColor = .red
    private let colorWithoutItem: UIColor = .blue
    
    private let colorSelected:    UIColor = .yellow
    private let colorCanDrop:     UIColor = .green
    
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
    
    init(size: CGSize, radius: CGFloat, type: CellType) {
        visualNode = SKShapeNode(rectOf: size, cornerRadius: radius)
        self.type = type
        super.init(texture: nil, color: .clear, size: size)
        self.name = "Cell"
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


enum CellType: String {
    case Inner
    case Outer
}
