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
import SKTiledKit

extension ProjectCommand {
    struct CreateSpriteKitObjectTypes : ParsableCommand {
        static var configuration = CommandConfiguration(commandName: "skobjects", abstract:"Creates or updates the object types file for the project ensuring the SKxxxxx types are all up to date")
        
        @OptionGroup
        var options : ProjectCommand.Options
        

        mutating func run() throws {
            
            let skPoint = SKObjectType("Point", color: .white)
            let skEdgeLoopPolygon = SKObjectType("Polygon", color:.clear)

            let skPhysical = SKObjectType("Physical", color: Color.clear).withProperties(PhysicalObjectProperty.allCases)
            
            let skLit = SKObjectType("Lit", color: Color.clear).withProperties(LitSpriteProperty.allCases)
            
            let skLight = SKObjectType("Light", color: .clear).withProperties(LightProperty.allCases)



                        
            do {
                let project = try Project(from: URL(fileURLWithPath: options.path))
                
                try SpriteKitEngine.objectTypes.write(to: project.objectTypesUrl)
                
                print("Wrote Objects to \(project.objectTypesUrl.standardized.path)")
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
}
