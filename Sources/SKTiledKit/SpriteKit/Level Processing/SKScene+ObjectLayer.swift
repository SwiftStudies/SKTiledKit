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

extension SKScene{
    
    /// Creates a shape node for the supplied path
    ///
    /// - Parameters:
    ///   - path: Path built in SpriteKit co-ordinate space
    ///   - position: Position in Tiled co-ordinate space
    ///   - degrees: The rotation in degrees (as specified in Tiled
    ///   - centered: If true the shape will be positioned as it was in tiled, but the center of rotation will be the center of the shape
    /// - Returns: The created node
    func shapeNode(with path:CGPath, position:CGPoint, rotation degrees:Double, centered:Bool) -> SKTKShapeNode{
        let position = position.transform()
        let radians = -degrees.cgFloatValue.radians
        
        var path = path
        //Rotate to create a new path
        var rotationTransform = CGAffineTransform(rotationAngle: radians)

        #warning("Force unwrap")
        path = path.copy(using: &rotationTransform)!

        if !centered {
            let shapeNode = SKTKShapeNode(path: path)
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
        
        let shapeNode = SKTKShapeNode(path: path)
        shapeNode.position = position
        shapeNode.position.x += center.x
        shapeNode.position.y += center.y
        
        return shapeNode
    }
    
    public func add(objects: ObjectLayer, to container: Container) throws {
        let objectLayerNode = SKNode()
        container.addChild(objectLayerNode)

        objectLayerNode.name = objects.name
        objectLayerNode.isHidden = !objects.visible
        objectLayerNode.alpha = CGFloat(objects.opacity)
        objectLayerNode.apply(propertiesFrom: objects)
        objectLayerNode.position = CGPoint(x: objects.x, y: objects.y).transform()
        
        for object in objects.objects {
            
            var objectNode : SKNode? = nil
            
            if let elipse = object as? EllipseObject {
                guard let path = elipse.cgPath else {
                    fatalError("Could not generate path for elipse")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x:elipse.x,y:elipse.y), rotation: elipse.rotation, centered: true)
            } else if let tileObject = object as? TileObject {
                guard let tile = tileObject.level.tiles[tileObject.gid] else {
                    throw SKTiledKitError.tileNotFound
                }
                let cachedNode = SKTileSets.tileCache[tile.uuid]
                guard let tileNode = cachedNode?.copy() as? SKTKSpriteNode else {
                    throw SKTiledKitError.tileNodeDoesNotExist
                }
                
                let size = tileNode.calculateAccumulatedFrame().size
                
                tileNode.anchorPoint = .zero
                tileNode.position = CGPoint(x: tileObject.x, y: tileObject.y).transform()
                tileNode.zRotation = -tileObject.rotation.cgFloatValue.radians
                tileNode.xScale = tileObject.width.cgFloatValue / size.width
                tileNode.yScale = tileObject.height.cgFloatValue / size.height
                
                objectNode = tileNode
                
            } else if let textObject = object as? TextObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: textObject.width, height: textObject.height).transform())

                let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

                textNode.add(textObject.string, applying: textObject.style)
                if object.showTextNodePath == true {
                    textNode.strokeColor = SKColor.white
                }

                textNode.position = CGPoint(x: textObject.x, y: textObject.y).transform()
                textNode.zRotation = -textObject.rotation.radians.cgFloatValue

                objectNode = textNode
            } else if let rectangle = object as? RectangleObject {
                guard let path = rectangle.cgPath else {
                    fatalError("Could not generate path for RectangleObject")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x:rectangle.x,y:rectangle.y), rotation: rectangle.rotation, centered: true)
                
            } else if let point = object as? PointObject {
                let pointNode = SKTKShapeNode(circleOfRadius: 1)
                
                pointNode.position = CGPoint(x: point.x, y: point.y).transform()
                
                objectNode = pointNode
            } else if let polygon = object as? PolygonObject {
                guard let path = polygon.cgPath else {
                    fatalError("Could not generate path for Polygonal Object")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x: polygon.x, y: polygon.y), rotation: polygon.rotation, centered: true)
            }
            
            if let objectNode = objectNode {
                objectNode.name = object.name
                objectNode.isHidden = !object.visible
                objectNode.apply(propertiesFrom: object)
                
                if let strokeColor : Color = object.strokeColor, let shapeNode = objectNode as? SKShapeNode {
                    shapeNode.strokeColor = strokeColor.skColor
                }
                
                objectLayerNode.addChild(objectNode)
            }
            
        }
    }
}
