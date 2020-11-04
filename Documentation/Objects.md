#  Objects

All of the different object types supported by Tiled are created as part of the SpriteKit scene

 - [Point](#point) 
 - [Elipse](#elipse) 
 - [Rectange](#rectangle) 
 - [Polygon](#polygon)  
 - [Polyline](#polyline) 
 - [Text](#text) 
 - [Image](#image) 

## <a name="point">Point</a>
Created as an  `SKShapeNode` which is a circle with a transparent center. As SpriteKit doesn't have a native representation of a point this is really to allow you to parse this object as you see fit.  

### Supported Properties

 - __Name__ Supported. `name` is set on the shape 
 - __Visible__ Supported. `isHidden` is set appropriatly on the shape
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="polyline">Polyline</a>

Created as an  `SKShapeNode`.

### Supported Properties

 - __Name__ Supported. `name` is set on the shape 
 - __Visible__ Supported. `isHidden` is set appropriatly on the shape
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Rotation__ Supported. The shape is rotated so that the visual appearence matches what is seen in Tiled. However, the resulting node can be rotated and will rotate about its center (unlike tiled where it will rotate around the origin of the shape's co-ordinate system)

### Support for user specified properties

All properties are copied to the [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) property of the created node. In addition the following properties are interpretted and applied:

 - `strokeColor : Color` is converted to an `SKColor` and set on the node's `strokeColor` property

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="polygon">Polygon</a>
Created as an  `SKShapeNode`.

### Supported Properties

 - __Name__ Supported. `name` is set on the shape 
 - __Visible__ Supported. `isHidden` is set appropriatly on the shape
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Rotation__ Supported. The shape is rotated so that the visual appearence matches what is seen in Tiled. However, the resulting node can be rotated and will rotate about its center (unlike tiled where it will rotate around the origin of the shape's co-ordinate system)

### Support for user specified properties

All properties are copied to the [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) property of the created node. In addition the following properties are interpretted and applied:

 - `strokeColor : Color` is converted to an `SKColor` and set on the node's `strokeColor` property

 ## <a name="elipse">Elipse</a>
 Created as an  [`SKShapeNode`](https://developer.apple.com/documentation/spritekit/skshape). 

 ### Supported Properties

  - __Name__ Supported. `name` is set on the shape 
  - __Visible__ Supported. `isHidden` is set appropriatly on the shape
  - __X__ Supported, sets `position.x`
  - __Y__ Supported, sets `position.y` 
  - __Width__ Supported. Captured in the path
  - __Height__ Supported. Captured in the path
  - __Rotation__ Supported. The shape is rotated so that the visual appearence matches what is seen in Tiled. However, the resulting node can be rotated and will rotate about its center (unlike tiled where it will rotate around the origin of the shape's co-ordinate system)

 ### Support for user specified properties

All properties are copied to the [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) property of the created node. In addition the following properties are interpretted and applied:

 - `strokeColor : Color` is converted to an `SKColor` and set on the node's `strokeColor` property

## <a name="rectangle">Rectangle</a>
Created as an  [`SKShapeNode`](https://developer.apple.com/documentation/spritekit/skshape). 

### Supported Properties

 - __Name__ Supported. `name` is set on the shape 
 - __Visible__ Supported. `isHidden` is set appropriatly on the shape
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Width__ Supported. Captured in the path
 - __Height__ Supported. Captured in the path
 - __Rotation__ Supported. The shape is rotated so that the visual appearence matches what is seen in Tiled. However, the resulting node can be rotated and will rotate about its center (unlike tiled where it will rotate around the origin of the shape's co-ordinate system)

### Support for user specified properties

All properties are copied to the [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) property of the created node. In addition the following properties are interpretted and applied:

 - `strokeColor : Color` is converted to an `SKColor` and set on the node's `strokeColor` property

## <a name="text">Text</a>
In order to support the text alignment options and origin behavior of the TiledKit level (the y-axis is inverted compared to SpriteKIt) an `SKLabelNode` is wrapped in an `SKShapeNode` with a rectangular path the same size as the width and height properties of the Text object in Tiled. 

### Supported Properties

 - __Name__ Supported. `name` is set on the label
 - __Visible__ Supported. `isHidden` is set appropriatly on the label
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Width__ Supported
 - __Height__ Supported
 - __Rotation__ Supported, applied to `zRotation`
 - __Text__ Supported, added as the `text` on the label
 - __Alignment__ Not supported
 - __Font__ Partially supported
    - __Family__ Supported, sets the `fontName` property
    - __Pixel Size__ Supported, sets the `fontSize` property
    - __Bold__ Not supported
    - __Italic__ Not supported
    - __Underline__ Not supported
    - __Strikeout__ Not supported
    - __Kerning__ Not supported
 - __Word Wrap__ Supported
 - __Color__ Supported, set on `fontColor`

### Support for user specified properties

 - `showTextNodePath : Bool` If `true` draws a path around the bounding box for a text node

All other properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="image">Image</a>
Created as an `SKSpriteNode` 

### Supported Properties

 - __Name__ Supported. `name` is set on the shape 
 - __Visible__ Supported. `isHidden` is set appropriatly on the shape
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Width__ Supported, applied as a scaling factor in `xScale`
 - __Height__ Supported, applied as a scaling factor in `yScale`
 - __Rotation__ Supported, applied to `zRotation`

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 
