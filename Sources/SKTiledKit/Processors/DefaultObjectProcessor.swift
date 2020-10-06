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

class DefaultObjectProcessor : ObjectProcessor{
    /// Creates a shape node for the supplied path
    ///
    /// - Parameters:
    ///   - path: Path built in SpriteKit co-ordinate space
    ///   - position: Position in Tiled co-ordinate space
    ///   - degrees: The rotation in degrees (as specified in Tiled
    ///   - centered: If true the shape will be positioned as it was in tiled, but the center of rotation will be the center of the shape
    /// - Returns: The created node
    func shapeNode(with path:CGPath, position:CGPoint, rotation degrees:Double, centered:Bool) -> SKShapeNode{
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

    
    func willCreate(nodeFor object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode? {
        
        var objectNode : SKNode?
        
        switch object.kind {
        case .point:
            let pointNode = SKShapeNode(circleOfRadius: 1)
            
            pointNode.position = object.position.cgPoint.transform()
            
            objectNode = pointNode
        case .polygon(_, let angle), .polyline(_, let angle), .ellipse(_, let angle), .rectangle(_, let angle):
            guard let path = object.cgPath else {
                fatalError("Could not generate path for Polygonal Object")
            }
            
            objectNode = shapeNode(with: path, position: object.position.cgPoint, rotation: angle, centered: true)
        case .tile(let tileGid, let drawSize, _):
            guard let tile = map[tileGid] else {
                throw SKTiledKitError.tileNotFound
            }
            
            let tileNode = try project.retrieve(asType: SKSpriteNode.self, from: tile.cachingUrl)
                            
            let size = tileNode.calculateAccumulatedFrame().size
            
            tileNode.anchorPoint = .zero
            tileNode.position = object.position.cgPoint.transform()
            tileNode.zRotation = object.zRotation
            tileNode.xScale = drawSize.width.cgFloatValue / size.width
            tileNode.yScale = drawSize.height.cgFloatValue / size.height
            
            objectNode = tileNode
        case .text(let string, let size, _, let style):
            let rect = CGRect(origin: .zero, size: size.cgSize.transform())

            let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

            textNode.add(string, applying: style)
            if object.properties["showTextNodePath"] == true {
                textNode.strokeColor = SKColor.white
            }

            textNode.position = object.position.cgPoint.transform()
            textNode.zRotation = object.zRotation

            objectNode = textNode

        }
    
        if let objectNode = objectNode {
            objectNode.name = object.name
            objectNode.isHidden = !object.visible
            objectNode.apply(propertiesFrom: object)
            
            if case let PropertyValue.color(strokeColor) = object.properties["strokeColor"] ?? .bool(false), let shapeNode = objectNode as? SKShapeNode {
                shapeNode.strokeColor = strokeColor.skColor
            }
            
        }
        
        return objectNode
    }
    
    func didCreate(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) -> SKNode {
        #warning("Should apply properties here")
        return node
    }
    
    
}
