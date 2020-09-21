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
    public func add(objects: ObjectLayer, to container: Container) throws {
        let node = SKNode()
        container.addChild(node)

        node.name = objects.name
        node.isHidden = !objects.visible
        node.alpha = CGFloat(objects.opacity)
        node.apply(propertiesFrom: objects)
        
        for object in objects.objects {
            
            var node : SKNode? = nil
            
            if let elipse = object as? EllipseObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: elipse.width, height: elipse.height).transform())

                let elipseNode = SKTKShapeNode(path: CGPath(ellipseIn: rect, transform: nil))
                
                elipseNode.position = CGPoint(x:elipse.x, y:elipse.y).transform()
                elipseNode.zRotation = -elipse.rotation.radians.cgFloatValue
                
                node = elipseNode
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
                
                node = tileNode
                
            } else if let textObject = object as? TextObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: textObject.width, height: textObject.height).transform())

                let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

                textNode.add(textObject.string, applying: textObject.style)
                if object.showTextNodePath == true {
                    textNode.strokeColor = SKColor.white
                }

                textNode.position = CGPoint(x: textObject.x, y: textObject.y).transform()
                textNode.zRotation = -textObject.rotation.radians.cgFloatValue

                node = textNode
            } else if let rectangle = object as? RectangleObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: rectangle.width, height: rectangle.height).transform())

                let rectangleNode = SKTKShapeNode(path: CGPath(rect: rect, transform: nil))
                rectangleNode.position = CGPoint(x:rectangle.x, y:rectangle.y).transform()
                rectangleNode.zRotation = -rectangle.rotation.radians.cgFloatValue

                node = rectangleNode
            } else if let point = object as? PointObject {
                let pointNode = SKTKShapeNode(circleOfRadius: 1)
                
                pointNode.position = CGPoint(x: point.x, y: point.y).transform()
                
                node = pointNode
            } else if let polygon = object as? PolygonObject {
                let path = CGMutablePath()
                var first = true
                for point in polygon.points {
                    if first {
                        path.move(to: CGPoint(x: point.x, y: point.y).transform())
                        first = false
                    } else {
                        path.addLine(to: CGPoint(x: point.x, y: point.y).transform())
                    }
                }
                
                if !(polygon is PolylineObject) {
                    path.closeSubpath()
                }
                
                let pathNode = SKTKShapeNode(path: path)

                pathNode.position = CGPoint(x: polygon.x, y: polygon.y).transform()
                pathNode.zRotation = -(polygon.rotation?.radians.cgFloatValue ?? 0)

                node = pathNode
            }
            
            if let node = node {
                node.name = object.name
                node.isHidden = !object.visible
                node.apply(propertiesFrom: object)
                
                container.addChild(node)
            }
            
        }
    }
}
