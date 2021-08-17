//
//  EntityManager.swift
//  Inventory
//
//  Created by Eugene Krapivenko on 01.08.2021.
//

import Foundation
import GameplayKit

class EntityManager {
    
    // MARK: - private
    private let systems: [GKComponentSystem<GKComponent>] = {
        var visualComponentObject = GKComponentSystem(componentClass: VisualComponent.self)
        var lockInventorySystem = GKComponentSystem(componentClass: LockComponent.self)
        var itemsMoveSystem = GKComponentSystem(componentClass: BackgroundMeshComponent.self)
        
        // !order
        return [visualComponentObject, lockInventorySystem, itemsMoveSystem]
    }()
    private var entities: Set<GKEntity> = Set<GKEntity>()
    
    // MARK: - public
    public var scene: SKScene?
    
    // MARK: - entities
    func add(entity: GKEntity) {
        entities.insert(entity)
        registryInSystems(entity: entity)
        
        if let node = entity.component(ofType: VisualComponent.self)?.node {
            scene?.addChild(node)
        }
    }
    
    func delete(entity: GKEntity) {
        if let node = entity.component(ofType: VisualComponent.self)?.node {
            scene?.removeChildren(in: [node])
        }
        
        removeFromSystems(entity: entity)
        entities.remove(entity)
    }
    
    func find <ComponentType: GKComponent>(entity: GKEntity, has component: ComponentType.Type ) -> GKEntity? {
        entities.first(where: { $0.isEqual(entity) && $0.component(ofType: component) != nil })
    }
    
    // TODO refactory
    func findEntity(with node: SKNode) -> GKEntity? {
        entities.first { entity in
            if let foundNode = entity.component(ofType: VisualComponent.self)?.node {
                return foundNode.isEqual(to: node)
            } else {
                return false
            }
        }
    }
    
    // MARK: - Components
    func add(component: GKComponent, to entity: GKEntity) {
        if entities.contains(entity) {
            self.registryInSystems(component: component, complition: entity.addComponent)
        } else {
            print("Entity not registry!")
        }
    }
    
    func delete(componentType: GKComponent.Type, from entity: GKEntity) {
        if entities.contains(entity) {
            if let targetComponent = entity.component(ofType: componentType) {
                self.removeFromSystems(component: targetComponent, complition: entity.removeComponent)
            } else {
                print("Entity has not have for this type \(componentType) component!")
            }
        } else {
            print("Entity not found")
        }
    }
    
    // MARK: - Systems
    private func registryInSystems(entity: GKEntity) {
        for system in systems {
            system.addComponent(foundIn: entity)
        }
    }
    
    private func removeFromSystems(entity: GKEntity) {
        for system in systems {
            system.removeComponent(foundIn: entity)
        }
    }
    
    private func registryInSystems(component: GKComponent, complition: (GKComponent) -> Void) {
        for system in systems {
            if (system.componentClass == type(of: component) && !system.components.contains(component)) {
                system.addComponent(component)
                complition(component)
            }
        }
    }
    
    private func removeFromSystems(component: GKComponent, complition: (GKComponent.Type) -> Void) {
        for system in systems {
            if (system.componentClass == type(of: component) && system.components.contains(component)) {
                system.removeComponent(component)
                complition(type(of: component))
            }
        }
    }
 
    // MARK: - Update
    func update(dt: TimeInterval) {
        for sistem in systems {
            sistem.update(deltaTime: dt)
        }
    }
}
