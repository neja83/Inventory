//
//  ScrollComponent.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 07.08.2021.
//

import Foundation
import GameplayKit

protocol BlockedComponent {
    var disabled: Bool { get }
    func setDisabled(_ value : Bool)
}

class ScrollComponent: GKComponent, BlockedComponent {
    
    var scroll: ScrollNode?
    var disabled: Bool = false {
        didSet {
            scroll?.disabled = self.disabled
        }
    }
    
    override init() {
        super.init()
    }
    
    override func didAddToEntity() {
        if let visual = entity?.component(ofType: VisualComponent.self),
           let backgroundMesh = entity?.component(ofType: BackgroundMeshComponent.self){
            
            let scrollNode = ScrollNode(size: visual.node.frame.size, background: backgroundMesh.node)
            
            self.scroll = scrollNode
            visual.node.addChild(scrollNode)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDisabled(_ value: Bool) {
        self.disabled = value
    }
    
}
