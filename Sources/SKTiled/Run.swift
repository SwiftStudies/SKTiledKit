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

struct Run : ParsableCommand {
    static var configuration =  CommandConfiguration(abstract:"Loads the specified level into a scene")

    @Argument
    var level : String
    
    func run() throws {
        do {
            let scene = try SKScene(tiledLevel: URL(fileURLWithPath: level, isDirectory: false, relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath)))
            
        } catch {
            print("Could not load level \"\(level)\":\t\(error)")
            throw error
        }
    }
}
