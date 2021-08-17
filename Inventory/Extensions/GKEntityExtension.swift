//
//  GKEntity.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 11.08.2021.
//

import Foundation
import GameplayKit

extension GKEntity {
    
    public func component<ComponentType, ProtocolType>(ofType componentClass: ComponentType.Type, where protocol: ProtocolType.Type ) -> ComponentType? where ComponentType : GKComponent {
        self.components.first(where: { component in
            if let _ = component as? ProtocolType {
                return true
            }
            return false
        }) as? ComponentType
    }
}
