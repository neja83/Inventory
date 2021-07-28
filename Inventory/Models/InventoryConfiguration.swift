//
//  Configurations.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 28.07.2021.
//

import Foundation
import SpriteKit

class InventoryConfiguration {
    
    // Global size
    public let inventorySize : InventorySize
    
    // Calculated size
    public let inventoryPointsSize: CGSize
    
    // Cell
    public var cellSize: CGSize = CGSize(width: 52, height: 52)
    
    // Cell padding
    public var padding:  CGFloat = 6
    
    init(size: InventorySize = InventorySize(lines: 3, columns: 3)) {
        self.inventorySize = size
        
        let width  = cellSize.width  * CGFloat(inventorySize.columns) + (CGFloat(inventorySize.columns - 1) * padding * 2)
        let height = cellSize.height * CGFloat(inventorySize.lines)   + (CGFloat(inventorySize.lines - 1)   * padding * 2)
        
        self.inventoryPointsSize = CGSize(width: width, height: height)
    }
    
}

// TODO: - texture's
struct InventoryColors { 
    
    static let defaultIventoryColor: UIColor = .gray
    static let cellDefaultColor: UIColor = .blue
}
