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

@dynamicMemberLookup
public class SKTKTextNode : SKShapeNode {
}

public extension SKTKTextNode {
    private static let textObjectNodeName = "TiledKit.TextObject"
    private var label : SKLabelNode? {
        return childNode(withName: Self.textObjectNodeName) as? SKLabelNode
    }
    
    var fontSize : CGFloat {
        get {
            return label?.fontSize ?? 0
        }
        set {
            label?.fontSize = newValue
        }
    }

    var fontColor : SKColor? {
        get {
            return label?.fontColor
        }
        set {
            label?.fontColor = newValue
        }
    }

    var fontName : String? {
        get {
            return label?.fontName
        }
        set {
            label?.fontName = newValue
        }
    }
        
    internal func add(_ text:String, applying style:TextStyle){
        strokeColor = SKColor.clear
        fillColor = SKColor.clear

        removeAllChildren()
        let labelNode = SKLabelNode(text: text)
        labelNode.name = SKTKTextNode.textObjectNodeName
        addChild(labelNode)

        apply(style)
    }
    
    func apply(_ style:TextStyle){
        guard let label = label else {
            return
        }
        let boundingBox = path?.boundingBox ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        fontSize = style.pixelSize.cgFloatValue
        if let fontFamily = style.fontFamily {
            fontName = fontFamily
        }
        fontColor = style.color.skColor
        
        if style.wrap {
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = boundingBox.width
        } else {
            label.numberOfLines = 1
            label.preferredMaxLayoutWidth = 1000000
        }
        
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        
        let textBounds = label.calculateAccumulatedFrame()
        
        switch style.horizontalAlignment {
        case .left, .justified:
            label.position.x = textBounds.width / 2
        case .center:
            label.position.x = boundingBox.width / 2
        case .right:
            label.position.x = boundingBox.width - (textBounds.width / 2)
        }
        
        switch style.verticalAlignment {
        case .top:
            label.position.y = textBounds.height / 2 - boundingBox.height
        case .middle:
            label.position.y = -(boundingBox.height / 2)
        case .bottom:
            label.position.y = -boundingBox.height + (textBounds.height / 2)
        }
    }
}
