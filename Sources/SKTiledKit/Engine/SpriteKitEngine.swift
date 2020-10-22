//    Copyright 2020 Swift Studies
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

import TiledKit
import SpriteKit

public final class SpriteKitEngine : Engine {
    public typealias FloatType = CGFloat
    public typealias ColorType = SKColor
    
    static var registeredActions = [String:SKAction]()
    
    public static func registerAction(key: String, action: SKAction){
        registeredActions[key] = action
    }
    
    public static func registerProducers() {
        registerStandardActions()
        register(producer: PhysicsPropertiesPostProcessor())
        register(producer: LightFactory())
        register(producer: EdgeLoopProcessor())
        register(producer: BridgablePropertyProcessor<SKNode>(applies: Interactable.allCases, to: .anyObject, with: "SKUserInterface"))
        register(producer: BridgablePropertyProcessor<SKSpriteNode>(applies: LitSpriteProperty.allCases, to: [.tileObject, .imageLayer]))
        register(producer: BridgablePropertyProcessor<SKLightNode>(applies: LightProperty.allCases, to: .pointObject, with: "SKLight" ))
        register(producer: CameraProcessor())
    }
    
    static var enginePrefix : String {
        return "SK"
    }
    
    public static var objectTypes : ObjectTypes {
        var engineTypes = ObjectTypes()
        
        engineTypes["\(enginePrefix)UserInterface"] = ObjectType(.lightGrey, with: Interactable.allCases)
        
        engineTypes["\(enginePrefix)Camera"] = ObjectType(.darkGrey,with: CameraProperty.allCases)

        engineTypes["\(enginePrefix)Shape"] = ObjectType(.green,with: NodeProperty.allCases).and(ShapeProperty.allCases).and(PhysicalObjectProperty.allCases)

        engineTypes["\(enginePrefix)Light"] = ObjectType(.yellow, with: NodeProperty.allCases).and(LightProperty.allCases)

        engineTypes["\(enginePrefix)EdgeLoop"] = ObjectType(.white, with: NodeProperty.allCases).and([PhysicalObjectProperty.physicsCategory, PhysicalObjectProperty.physicsCollisionMask, PhysicalObjectProperty.physicsContactMask, PhysicalObjectProperty.friction, PhysicalObjectProperty.restitution])

        engineTypes["\(enginePrefix)Sprite"] = ObjectType(.blue,
                                                          with:
                 NodeProperty.allCases)
            .and(PhysicalObjectProperty.allCases)
            .and(LitSpriteProperty.allCases)

        return engineTypes
    }
}


