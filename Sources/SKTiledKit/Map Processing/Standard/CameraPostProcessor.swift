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

fileprivate extension ObjectProtocol {
    var isTypedAsCamera : Bool {
        return type ?? "" == "SKCamera"
    }
}

public class CameraProcessor : TiledKit.ObjectPostProcessor, TiledKit.MapPostProcessor {
    public typealias EngineType = SpriteKitEngine
    


    
    public func makeCamera(_ rectangle: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        guard object.type ?? "" == "SKCamera" else {
            return rectangle
        }

        if let value = object.properties["trackObject"], case let PropertyValue.object(id: trackId) = value {
            self.trackId = trackId
        }
        
        self.cameraShape = rectangle
        
        frame = rectangle.calculateAccumulatedFrame()
        
        return rectangle
    }
    
    public func warn<O>(_ kind:TiledType,object:O, typedAsCamera camera:Bool)->O{
        
        if camera {
            EngineType.warn("\(kind) cannot be a camera")
        }
        
        return object
    }
    
    public func process(rectangle: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        
        return try makeCamera(rectangle, from: object, for: map, from: project)
    }
    
    public func process(ellipse: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        if object.isTypedAsCamera {
            return warn(object.tiledType, object: ellipse, typedAsCamera: true)
        }
        return ellipse
    }
    
    public func process(polygon: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        if object.isTypedAsCamera {
            return warn(object.tiledType, object: polygon, typedAsCamera: true)
        }
        return polygon
    }
    
    public func process(polyline: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        if object.isTypedAsCamera {
            return warn(object.tiledType, object: polyline, typedAsCamera: true)
        }
        return polyline
    }
    
    public func process(point: SKNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKNode {
        return warn(.pointObject, object: point, typedAsCamera: object.isTypedAsCamera)
    }
    
    public func process(sprite: SKSpriteNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKSpriteNode {
        return warn(.tileObject, object: sprite, typedAsCamera: object.isTypedAsCamera)
    }
    
    public func process(text: SKTKTextNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKTKTextNode {
        return warn(.textObject, object: text, typedAsCamera: object.isTypedAsCamera)
    }

    var frame : CGRect? = nil
    var cameraShape : SKShapeNode? = nil
    var trackId : Int? = nil
    
    public init(){
        
    }
    
    public func process(_ node: SKNode, of type: String?, with properties: Properties) throws -> SKNode {
        if type ?? "" == "SKCamera" {
            SceneLoader.warn("Tile nodes cannot be Cameras")
        }
        return node
    }
    
    
    public func process(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode {
        guard object.type ?? "" == "SKCamera" else {
            return node
        }

        if let value = object.properties["trackObject"], case let PropertyValue.object(id: trackId) = value {
            self.trackId = trackId
        }
        
        guard let cameraShape = node as? SKShapeNode else {
            return node
        }
        
        self.cameraShape = cameraShape
        
        frame = cameraShape.calculateAccumulatedFrame()
        
        return node
    }
    
    public func process(engineMap: EngineType.MapType, for map: Map, from project: Project) throws -> EngineType.MapType {
        let scene = engineMap
        
        guard let frame = frame, let cameraShape = cameraShape else {
            return scene
        }
        
        scene.size = frame.size
        
        let cameraNode = SKCameraNode()

        cameraNode.position = cameraShape.position
        scene.addChild(cameraNode)
        scene.camera = cameraNode
        
        cameraShape.removeFromParent()
        
        // Setup constraints
        var constraints = [ SKConstraint.positionX(SKRange.init(lowerLimit: frame.size.width/2, upperLimit: map.pixelSize.width.cgFloatValue-(frame.size.width/2)), y: SKRange.init(lowerLimit: -frame.size.height/2, upperLimit: -map.pixelSize.height.cgFloatValue+(frame.size.height/2)))]
 
        defer {
            cameraNode.constraints = constraints
        }
        
        guard let trackId = trackId else {
            return scene
        }
        
        if let trackedNode = scene.child(withTiledObject: trackId) {
            constraints.append(SKConstraint.distance(SKRange(upperLimit: 0), to: trackedNode))
        }
                
        return scene
    }
}
