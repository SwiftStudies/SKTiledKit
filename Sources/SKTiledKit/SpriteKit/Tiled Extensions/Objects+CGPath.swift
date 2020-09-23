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

public extension CGPath {
    func apply(_ transform:CGAffineTransform)->CGPath {
        var transform = transform
        
        return copy(using: &transform)!
    }
}

extension Object {
    
    public var zRotation: CGFloat {
        if let rectObject = self as? RectangleObject {
            return -rectObject.rotation.cgFloatValue.radians
        } else if let pologonalObject = self as? PolygonObject {
            return -pologonalObject.rotation.cgFloatValue.radians
        }
        
        return 0
    }
    
    public var cgPath: CGPath? {
        if self is TextObject || self is TileObject || self is PointObject{
            return nil
        } else if let elipse = self as? EllipseObject {
            let rect = CGRect(origin: .zero, size: CGSize(width: elipse.width, height: elipse.height).transform())

            return CGPath(ellipseIn: rect, transform: nil)
        } else if let rectangle = self as? RectangleObject {
            let rect = CGRect(origin: .zero, size: CGSize(width: rectangle.width, height: rectangle.height).transform())

            return CGPath(rect: rect, transform: nil)
        } else if let polygonal = self as? PolygonObject {
            let path = CGMutablePath()
            var first = true
            for point in polygonal.points {
                if first {
                    path.move(to: CGPoint(x: point.x, y: point.y).transform())
                    first = false
                } else {
                    path.addLine(to: CGPoint(x: point.x, y: point.y).transform())
                }
            }
            
            if !(polygonal is PolylineObject) {
                path.closeSubpath()
            }
            
            return path
        }
        
        return nil
    }
}

