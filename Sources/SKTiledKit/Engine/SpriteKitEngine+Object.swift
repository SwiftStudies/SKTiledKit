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
    var cgPath : CGPath? {
        if let object = self as? Object {
            return object.cgPath
        }
        
        return nil
    }
}

public extension SpriteKitEngine {
    typealias PointObjectType = SKNode
    typealias RectangleObjectType = SKShapeNode
    typealias EllipseObjectType = SKShapeNode
    typealias TextObjectType = SKTKTextNode
    typealias PolylineObjectType = SKShapeNode
    typealias PolygonObjectType = SKShapeNode

    fileprivate static func configure(_ node:SKNode, for object:ObjectProtocol){
        node.name = object.name
        node.isHidden = !object.visible
        node.apply(propertiesFrom: object)
        
        if case let PropertyValue.color(strokeColor) = object.properties["strokeColor"] ?? .bool(false), let shapeNode = node as? SKShapeNode {
            shapeNode.strokeColor = strokeColor.skColor
        }
    }
    
    static func make(pointFor object: ObjectProtocol, in map: Map, from project: Project) throws -> SKNode {
        let pointNode = SKShapeNode(circleOfRadius: 1)
        
        pointNode.position = object.position.cgPoint.transform()

        return pointNode
    }
    
    static func make(rectangleOf size: Size, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode {
        return try make(shapeWith: object.cgPath, at: angle, for: object, in: map, from: project)
    }
    
    static func make(ellipseOf size: Size, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode {
        return try make(shapeWith: object.cgPath, at: angle, for: object, in: map, from: project)
    }
        
    static func make(polylineWith path: Path, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode {
        return try make(shapeWith: object.cgPath, at: angle, for: object, in: map, from: project)
    }
    
    static func make(polygonWith path: Path, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKShapeNode {
        
        return try make(shapeWith: object.cgPath, at: angle, for: object, in: map, from: project)
    }
    
    static func make(spriteWith tile: SKSpriteNode, of size: Size, at angle: Double, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKSpriteNode {
                        
        let size = tile.calculateAccumulatedFrame().size
        
        tile.anchorPoint = .zero
        tile.position = object.position.cgPoint.transform()
        tile.zRotation = object.zRotation
        tile.xScale = size.width.cgFloatValue / size.width
        tile.yScale = size.height.cgFloatValue / size.height
        
        return tile
    }
    
    static func make(textWith string: String, of size: Size, at angle: Double, with style: TextStyle, for object: ObjectProtocol, in map: Map, from project: Project) throws -> SKTKTextNode {
        
        let rect = CGRect(origin: .zero, size: size.cgSize.transform())

        let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

        textNode.add(string, applying: style)
        if object.properties["showTextNodePath"] == true {
            textNode.strokeColor = SKColor.white
        }

        textNode.position = object.position.cgPoint.transform()
        textNode.zRotation = object.zRotation

        return textNode
    }
    
    fileprivate static func make(shapeWith path:CGPath?, at angle:Double, for object: ObjectProtocol, in map:Map, from project: Project) throws -> SKShapeNode {
        
        guard let path = path else {
            throw SceneLoadingError.couldNotCreatePathForObject(object)
        }
        
        let node = shapeNode(with: path, position: object.position.cgPoint, rotation: angle, centered: true)
        
        if object.hasProperty(in: PhysicalObjectProperty.allCases) {
            let size = node.calculateAccumulatedFrame().size
            node.physicsBody = SKPhysicsBody(polygonFrom: path.apply(CGAffineTransform(translationX: -size.width / 2, y: size.height / 2)))
        }
        
        return node
    }
    
    /// Creates a shape node for the supplied path
    ///
    /// - Parameters:
    ///   - path: Path built in SpriteKit co-ordinate space
    ///   - position: Position in Tiled co-ordinate space
    ///   - degrees: The rotation in degrees (as specified in Tiled
    ///   - centered: If true the shape will be positioned as it was in tiled, but the center of rotation will be the center of the shape
    /// - Returns: The created node
    fileprivate static func shapeNode(with path:CGPath, position:CGPoint, rotation degrees:Double, centered:Bool) -> SKShapeNode{
        let position = position.transform()
        let radians = -degrees.cgFloatValue.radians
        
        var path = path
        //Rotate to create a new path
        var rotationTransform = CGAffineTransform(rotationAngle: radians)

        #warning("Force unwrap")
        path = path.copy(using: &rotationTransform)!

        if !centered {
            let shapeNode = SKShapeNode(path: path)
            shapeNode.position = position
            return shapeNode
        }
        
        var total = 0
        var xSum : CGFloat = 0
        var ySum : CGFloat = 0
        
        path.applyWithBlock { (pathElementPointer) in
            
            if !pathElementPointer.pointee.points.pointee.x.isNaN {
                xSum += pathElementPointer.pointee.points.pointee.x
                ySum += pathElementPointer.pointee.points.pointee.y
                total += 1
            }
        }
        
        let center = CGPoint( x: xSum / total.cgFloatValue, y: ySum / total.cgFloatValue)
        
        var centeringTransform = CGAffineTransform(translationX: -center.x, y: -center.y)
        
        #warning("Force unwrap")
        path = path.copy(using: &centeringTransform)!
        
        let shapeNode = SKShapeNode(path: path)
        shapeNode.position = position
        shapeNode.position.x += center.x
        shapeNode.position.y += center.y
        
        return shapeNode
    }

    
}
