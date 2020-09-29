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

import SpriteKit
import TiledKit

extension Tile {
    internal var cachingUrl : URL {
        let encodedPath = imageSource.pathComponents.reduce("", {"\($0)/\($1.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)"})
        return URL(inMemory: "TileNode", encodedPath,"\(bounds.origin.x)","\(bounds.origin.y)","\(bounds.size.width)","\(bounds.size.height)")!
    }
}

public struct TileLoader : ResourceLoader {
    let project : Project
    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R where R : Loadable {
        throw SceneLoadingError.attemptToLoadInMemoryResourceFrom(url)
    }
}

extension SKSpriteNode : Loadable {
    public static func loader(for project: Project) -> ResourceLoader {
        return TileLoader(project: project)
    }
    
    public var cache: Bool {
        return true
    }
    
    public func newInstance() -> Self {
        if let nodeCopy = self.copy() as? Self {
            return nodeCopy
        }
        fatalError("Could not create a copy of SKNode for a new instance")
    }
    
    
}
