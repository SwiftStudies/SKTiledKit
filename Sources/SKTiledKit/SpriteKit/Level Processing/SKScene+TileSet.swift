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

extension SKScene {
    public func create(tileSet: TileSet) throws {
        try SKTileSets.load(tileSet)
    }
    
    #warning("This may not be necessary")
    public func add(tile: Int, to tileSet: TileSet) throws {
        throw SKTiledKitError.notImplemented
    }
}
