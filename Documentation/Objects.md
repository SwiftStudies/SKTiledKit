#  Objects

Not all objects types are supported yet. The following support is available. 

 - [Point](#point) Not supported
 - [Elipse](#elipse) Supported
 - [Rectange](#rectangle) Supported
 - [Polygon](#polygon) Not supported
 - [Polyline](#polyline) Not supported
 - [Text](#text) Supported
 - [Image](#image) Not supported
 
 ## <a name="elipse">Elipse</a>
 Created as an  [`SKShape`](https://developer.apple.com/documentation/spritekit/skshape). 

 ### Supported Properties

  - __Name__ Supported. `name` is set on the shape 
  - __Visible__ Supported. `isHidden` is set appropriatly on the shape
  - __X__ Supported, sets `position.x`
  - __Y__ Supported, sets `position.y` 
  - __Width__ Supported. Captured in the path
  - __Height__ Supported. Captured in the path
  - __Rotation__ Not supported

 ### Support for user specified properties

 No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="rectangle">Rectangle</a>
Created as an  [`SKShape`](https://developer.apple.com/documentation/spritekit/skshape). 

### Supported Properties

 - __Name__ Supported. `name` is set on the shape 
 - __Visible__ Supported. `isHidden` is set appropriatly on the shape
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Width__ Supported. Captured in the path
 - __Height__ Supported. Captured in the path
 - __Rotation__ Not supported

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="text">Text</a>
Created as an  [`SKLabelNode`](https://developer.apple.com/documentation/spritekit/sklabelnode). 

### Supported Properties

 - __Name__ Supported. `name` is set on the label
 - __Visible__ Supported. `isHidden` is set appropriatly on the label
 - __X__ Supported, sets `position.x`
 - __Y__ Supported, sets `position.y` 
 - __Width__ Not supported
 - __Height__ Not supported
 - __Rotation__ Not supported
 - __Text__ Supported, added as the `text` on the label
 - __Alignment__ Not supported
 - __Font__ Not supported
 - __Word Wrap__ Not supported
 - __Color__ Supported, set on `fontColor`

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 
