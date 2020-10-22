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
import Foundation

public enum SKTiledKitError : Error {
    case userDataNotCreatedFor(String)
    case obsolete(String)
    case couldNotCreatePathForObject(ObjectProtocol)
    case tileNodeDoesNotExist
    case tileNotFound
    case tileHasNoTileSet(tile:Tile)
    case notImplemented
    case missingPathForTile(tile:String)
    case couldNotLoadImage(url:URL)
    case imageFileNotFound(url:URL)
    case couldNotCreateImage(url:URL)
    case noPositionForTile(identifier:Int, tileSet:String)
    case unexpectedTypeForProperty(tiledPropertyName:String, tiledPropertyType:String)
}

