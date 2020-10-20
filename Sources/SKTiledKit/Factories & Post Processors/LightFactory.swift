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

#warning("API: Create single purpose layer and object factories and processors for simplicity")
public struct LightFactory : TiledKit.ObjectFactory {
    public typealias EngineType = SpriteKitEngine
    
    public func make(pointFor object: ObjectProtocol, in map: Map, from project: Project) throws -> SKNode? {
        guard let type = object.type, type == "SKLight" else {
            return nil
        }
        
        let lightNode = SKLightNode()
        
        lightNode.position = object.position.cgPoint.transform()
        
        return lightNode
    }
    
    fileprivate func warn(ofIncompatible object:ObjectProtocol){
        if object.type == "SKLight" {
            SpriteKitEngine.warn("Object \(object.name.isEmpty ? "\(object.id)" : object.name) is an SKLight, but is not a Point object. SKLight can only be applied to Tiled Point objects.")
        }
    }
    
    public func make(rectangleOf size: Size, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode? {
        warn(ofIncompatible: object); return nil
    }
    
    public func make(ellipseOf size: Size, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode? {
        warn(ofIncompatible: object); return nil
    }
    
    public func make(spriteWith tileId: TileGID, of size: Size, at angle: Double, with tiles: MapTiles<SpriteKitEngine>, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKSpriteNode? {
        warn(ofIncompatible: object); return nil
    }
    
    public func make(textWith string: String, of size: Size, at angle: Double, with style: TextStyle, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKTKTextNode? {
        warn(ofIncompatible: object); return nil
    }
    
    public func make(polylineWith path: Path, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode? {
        warn(ofIncompatible: object); return nil
    }
    
    public func make(polygonWith path: Path, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode? {
        warn(ofIncompatible: object); return nil
    }
}
