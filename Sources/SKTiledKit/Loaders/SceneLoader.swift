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

enum SceneLoadingError : Error {
    case obsolete(String)
    case couldNotCreateTile(UInt32, tileSet:String)
    case couldNotCreatePathForObject(ObjectProtocol)
    case sceneCouldNotReturned
    case textureCouldNotBeReturned
    case attemptToLoadInMemoryResourceFrom(URL)
    case tileNotFound(UInt32, tileSet:String)
}

#warning("ACTION: Delete file")
public extension Project {
    func retrieve(scene name:String, in subdirectory:String? = nil) throws -> SKScene {
        return try retrieve(asType: SKScene.self, from: name, in: subdirectory, of: .tmx)
    }
}


public struct SceneLoader : ResourceLoader {
    static var tileProcessors = [TileProcessor]()
    
    public static var factories : [Factory] = [
    ]
    
    public static var postProcessors : [PostProcessor] = [
    ]
    
    let project : Project
        
    var mapFactories : [MapFactory] {
        return Self.factories.compactMap {
            return $0 as? MapFactory
        }
    }

    var layerFactories : [LayerFactory] {
        return Self.factories.compactMap {
            return $0 as? LayerFactory
        }
    }

    var objectFactories : [ObjectFactory] {
        return Self.factories.compactMap {
            return $0 as? ObjectFactory
        }
    }
    
    var textureFactories : [TextureFactory] {
        return Self.factories.compactMap {
            return $0 as? TextureFactory
        }
    }
    
    var tileFactories : [TileFactory] {
        return Self.factories.compactMap {
            return $0 as? TileFactory
        }
    }

    
    var mapPostProcessors : [MapPostProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? MapPostProcessor
        }
    }

    var layerPostProcessors : [LayerPostProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? LayerPostProcessor
        }
    }

    var objectPostProcessors : [ObjectPostProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? ObjectPostProcessor
        }
    }

    var texturePostProcessors : [TextureProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? TextureProcessor
        }
    }

    var tilePostProcessors : [TileProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? TileProcessor
        }
    }
    
    public static func warn(_ message:String){
        print("Warning:\(message)")
    }
    
    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R {
        throw SceneLoadingError.obsolete("SceneLoader.retreive")
    }
    
    public func walk(_ objects: [Object], from layer:Layer, to container: SKNode, in map:Map) throws {
        
        for object in objects {
            var objectNode : SKNode! = nil

            for objectProcessor in objectFactories {
                if let createdNode = try objectProcessor.make(nodeFor: object, in: layer, and: map, from: project) {
                    objectNode = createdNode
                    break
                }
            }


            // Always tag the node with the objectId
            objectNode.userData = NSMutableDictionary()
            objectNode.userData?["tiledId"] = object.id
            
            for objectProcessor in objectPostProcessors {
                objectNode = try objectProcessor.process(objectNode, for: object, in: layer, and: map, from: project)
            }

            container.addChild(objectNode)
        }
    }
    
    public func walk(_ layers:[Layer], in map:Map, with parent:SKNode) throws {
        
        for layer in layers {
            var layerNode : SKNode!
            
            for factory in layerFactories {
                if let createdNode = try factory.make(nodeFor: layer, in: map, from: project){
                    layerNode = createdNode
                    break
                }
            }
            
            switch layer.kind {
            case .group(let group):
                try walk(group.layers, in: map, with: layerNode)
            case .objects(let objects):
                try walk(objects, from: layer, to: layerNode, in: map)
            default:
                break
            }

            for layerProcessor in layerPostProcessors {
                layerNode = try layerProcessor.process(layerNode, for: layer, in: map, from: project)
            }
            
            parent.addChild(layerNode)
        }
    }
    
    internal func apply(map : Map, to scene:SKScene) throws {
        throw SceneLoadingError.obsolete("SceneLoader.apply")
    }
    
    internal func makeTexture(for imageUrl:URL, with bounds:PixelBounds, and properties:Properties,  from project:Project) throws -> SKTexture{
        
        throw SceneLoadingError.obsolete("SceneLoader.makeTexture")
    }
    
    internal func load(_ tileset:TileSet) throws {
        throw SceneLoadingError.obsolete("SceneLoader.load(tileset)")
    }
}
