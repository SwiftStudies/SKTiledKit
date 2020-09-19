#  Objects

Not all objects types are supported yet. The following support is available. 

 - [Point](#point) Not supported
 - [Elipse](#elipse) Supported
 - [Rectange](#rectangle) Supported
 - [Polygon](#polygon) Not supported
 - [Polyline](#polyline) Not supported
 - [Text](#text) Not supported
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
