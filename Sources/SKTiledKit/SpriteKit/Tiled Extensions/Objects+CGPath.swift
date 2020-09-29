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
        switch self.kind {
        case .point:
            return 0
        case .rectangle(_,let angle), .ellipse(_, let angle), .tile(_,_,let angle), .text(_,_,let angle,_), .polygon(_, let angle), .polyline(_, let angle):
            return -angle.cgFloatValue.radians
        }
    }
    
    public var cgPath: CGPath? {
        switch kind {
        case .point, .text, .tile:
            return nil
        case .rectangle(let rectangle, _):
            let rect = CGRect(origin: .zero, size: CGSize(width: rectangle.width, height: rectangle.height).transform())

            return CGPath(rect: rect, transform: nil)
        case .ellipse(let ellipse, _):
            let rect = CGRect(origin: .zero, size: CGSize(width: ellipse.width, height: ellipse.height).transform())

            return CGPath(ellipseIn: rect, transform: nil)
        case .polygon(let pathPoints, _), .polyline(let pathPoints, _):
            let path = CGMutablePath()
            var first = true
            for point in pathPoints {
                if first {
                    path.move(to: CGPoint(x: point.x, y: point.y).transform())
                    first = false
                } else {
                    path.addLine(to: CGPoint(x: point.x, y: point.y).transform())
                }
            }
            
            if case let Object.Kind.polygon = kind {
                path.closeSubpath()
            }
            
            return path
        }
    }
}

