#  Layers

All of the different types of layer Tiled provides are supported. 

 - [Tile Layer](#tile-layer) 
 - [Group Layer](#group-layer) 
 - [Object Layer](#object-layer) 
 - [Image Layer](#image-layer) 

## <a name="tile-layer">Tile Layer</a>

Tile layers are supported and use [`SKNode`s](https://developer.apple.com/documentation/spritekit/sknode?language=swift) created to represent tiles from [Tile Sets](Tile%20Sets.md) as children.   

### Supported Properties

 - __Name__ Supported. `name` is set on the created [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift)
 - __Visible__ Supported
 - __Locked__ Not supported
 - __Opacity__ Supported. `alpha` is set appropriately on the created [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift)
 - __Tint Color__ Not supported 
 - __Horizontal Offset__ Supported
 - __Vertical Offset__ Supported

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="group-layer">Group Layer</a>
Group layers are supported, and by default result in an [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift) being created with the children of the group being children of the node. 

### Supported Properties

- __Name__ Supported. `name` is set on the created [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift)
- __Visible__ Supported. `isHidden` is set appropriately
- __Locked__ Not supported
- __Opacity__ Supported. `alpha` is set appropriately 
- __Tint Color__ Not supported 
- __Horizontal Offset__ Applied to the `position.x` of the node
- __Vertical Offset__ Applied to the `position.y` of the node


### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="object-layer">Object Layer</a>
Object layers are supported, and by default result in an [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift) being created. [Objects](Objects.md) are added as children of the node.

### Supported Properties

- __Name__ Supported. `name` is set on the created [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift)
- __Visible__ Supported. `isHidden` is set appropriately
- __Locked__ Not supported
- __Opacity__ Supported. `alpha` is set appropriately 
- __Tint Color__ Not supported 
- __Color__ Not supported 
- __Horizontal Offset__ Supported
- __Vertical Offset__ Supported
- __Drawing Order__ Not supported

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="image-layer">Image Layer</a>
Image layers are created as `SKTKSpriteNode`s. 

### Supported Properties

- __Name__ `name` is set on the created [`SKSpriteNode`](https://developer.apple.com/documentation/spritekit/skspritenode)
- __Visible__ Sets `isHidden`
- __Locked__ Not supported
- __Opacity__ `alpha` is set appropriately 
- __Tint Color__ Not supported 
- __Horizontal Offset__ Applied to the sprite's `position.x`
- __Vertical Offset__ Applied to the sprite's `position.y`
- __Image__ Supported and defines the `SKTexture` for the sprite

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties will be added to the  [`SKSpriteNode`](https://developer.apple.com/documentation/spritekit/skspritenode) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 
