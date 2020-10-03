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

import Foundation
import ArgumentParser
import TiledKit

extension ProjectCommand {
    struct CreateSpriteKitObjectTypes : ParsableCommand {
        static var configuration = CommandConfiguration(commandName: "skobjects", abstract:"Creates or updates the object types file for the project ensuring the SKxxxxx types are all up to date")
        
        @OptionGroup
        var options : ProjectCommand.Options
        

        mutating func run() throws {
            
            // Shapes
            let defaultShapeProperties : [SKProperty] = [.strokeColor, .fillColor]
            
            let skRectangle = SKObjectType("Rectangle", color: .white).withProperties(defaultShapeProperties)
            let skEllipse = SKObjectType("Ellipse", color: .white).withProperties(defaultShapeProperties)
            let skPolygon = SKObjectType("Polygon", color: .white).withProperties(defaultShapeProperties)
            let skPoint = SKObjectType("Point", color: .white)
            
            let skEdgeLoopPolygon = SKObjectType("Polygon", color:.clear)

            let skPhysical = SKObjectType("Physical", color: Color.clear).withProperties(.physicsCategory, .physicsCollisionMask, .physicsContactMask, .physicsPreciseCollisions, .affectedByGravity, .allowsRotation, .isDynamic, .mass, .friction, .restitution, .linearDamping, .angularDamping)
            
            let skLit = SKObjectType("Lit", color: Color.clear).withProperties(.litByMask, .shadowedByMask, .castsShadowsByMask, .normalImage)
            
            let skLight = SKObjectType("Light", color: .clear).withProperties(.lightCategory, .ambientColor, .lightColor, .shadowColor, .falloff, .direction)


            let skTypes = [
                SKObjectType("RectangleCamera", color: .darkGrey).withProperties(.trackObject),
                SKObjectType("Node", color: .green, inherits: skRectangle, skPhysical, skLit),
                SKObjectType("Node", color: .green, inherits: skEllipse, skPhysical, skLit),
                SKObjectType("Node", color: .green, inherits: skPolygon, skPhysical, skLit),
                SKObjectType("Node", color: .yellow, inherits: skPoint, skLight),
                SKObjectType("EdgeLoop", color: .white, inherits: skEdgeLoopPolygon, skPhysical),
                SKObjectType("Sprite", color: .blue, inherits: skPhysical, skLit)
            ]
            
            do {
                let project = try Project(from: URL(fileURLWithPath: options.path))
                var objectTypes = ObjectTypes()

                // Copy across any previous object types that aren't prefixed with SK
                for name in project.objectTypes.allNames {
                    if !name.hasPrefix("SK") {
                        objectTypes[name] = project.objectTypes[name]
                    }
                }
                
                for skType in skTypes {
                    objectTypes["SK\(skType.name)"] = skType.objectType
                }
                
                try objectTypes.write(to: project.objectTypesUrl)
                
                print("Wrote Objects to \(project.objectTypesUrl.standardized.path)")
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
}
