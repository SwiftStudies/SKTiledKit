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


import TiledResources
import TiledKit
import Foundation

import TiledKit

public enum TiledResourcesError : Error {
    case resourceIsNotAProjectResource(URL)
}

public extension Resource {
    internal var asProjectResource : ProjectResource?  {
        return self as? ProjectResource
    }
    func loadTileSet<O:TileSet>() throws -> O {
        guard let projectResource = asProjectResource else {
            throw TiledResourcesError.resourceIsNotAProjectResource(url)
        }
        return try Project(at: projectResource.project.url).retrieve(asType: O.self, from: url)
    }

    func loadMap() throws -> Map {
        guard let projectResource = asProjectResource else {
            throw TiledResourcesError.resourceIsNotAProjectResource(url)
        }
        return try Project(at: projectResource.project.url).retrieve(asType: Map.self, from: url)
    }
    
    func loadMap<E:Engine>(for engine:E.Type) throws ->E.MapType {
        guard let projectResource = asProjectResource else {
            throw TiledResourcesError.resourceIsNotAProjectResource(url)
        }
        return try Project(at: projectResource.project.url).retrieve(asType: E.MapType.self, from: url)
    }
}
