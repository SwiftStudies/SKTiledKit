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

import ArgumentParser
import SpriteKit
import SKTiledKit
import TiledKit

struct Run : ParsableCommand {
    static var configuration =  CommandConfiguration(abstract:"Loads the specified level into a scene")

    @Argument
    var level : String
    
    @Option(name: [.customShort("w"), .long], help:"Specifies specific size of the window, defaults to the size of the level", transform: {(input:String) throws -> (Int,Int)? in
        let dimensionComponents = input.trimmingCharacters(in: CharacterSet.whitespaces).split(separator: "x")
        guard dimensionComponents.count == 2 else {
            print("WARNING: Window size ignored, should be specified in form <width>x<height> (e.g. 1024x768)")
            return nil
        }
        guard let x = Int(dimensionComponents[0]), let y = Int(dimensionComponents[1]) else {
            print("WARNING: Window size ignored, should be specified in form <Integer>x<Integer> (e.g. 1024x768)")
            return nil
        }
        return (x,y)
    })
    var windowSize : (x:Int,y:Int)?
    
    func run() throws {
        do {
            let sceneUrl = URL(fileURLWithPath: level)
            let project = Project(at: sceneUrl.deletingLastPathComponent())
                        
            let scene = try project.retrieve(asType: SKScene.self, from: sceneUrl)
            
            scene.scaleMode = .aspectFit
            
            if let windowSize = windowSize {
                start(scene, from: sceneUrl, windowSize:CGSize(width: windowSize.x, height: windowSize.y))
            } else {
                start(scene, from: sceneUrl)
            }
            
        } catch {
            print("Could not load level \"\(level)\":\t\(error)")
            throw error
        }
    }
}
