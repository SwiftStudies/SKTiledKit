#  Layers

Not all kinds of layers, or standard properties of layers are supported yet. The following support is currently available.  

 - [Tile Layer](#tile-layer) Supported
 - [Group Layer](#group-layer) Supported
 - [Object Layer](#object-layer) Supported
 - [Image Layer](#image-layer) Not supported

## <a name="tile-layer">Tile Layer</a>

Tile layers are supported and use [`SKNode`s](https://developer.apple.com/documentation/spritekit/sknode?language=swift) created to represent tiles from [Tile Sets](Tile%20Sets.md) as children.   

### Supported Properties

 - __Name__ Supported. `name` is set on the created [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift)
 - __Visible__ Supported
 - __Locked__ Not supported
 - __Opacity__ Supported. `alpha` is set appropriately on the created [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode?language=swift)
 - __Tint Color__ Not supported 
 - __Horizontal Offset__ Not supported
 - __Vertical Offset__ Not supported

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
- __Horizontal Offset__ Not supported
- __Vertical Offset__ Not supported


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
- __Horizontal Offset__ Not supported
- __Vertical Offset__ Not supported
- __Drawing Order__ Not supported

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the  [`SKNode`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 

## <a name="image-layer">Image Layer</a>
Image layers are not yet fully supported by TiledKit, so SKTiledKit can't support them. When they are availble they will be implemented as an [`SKSpriteNode`](https://developer.apple.com/documentation/spritekit/skspritenode)
### Supported Properties

- __Name__ Not supported. `name` will be set on the created [`SKSpriteNode`](https://developer.apple.com/documentation/spritekit/skspritenode)
- __Visible__ Not supported. Will set `isHidden`
- __Locked__ Not supported
- __Opacity__ Not supported. `alpha` will be appropriately 
- __Tint Color__ Not supported 
- __Horizontal Offset__ Not supported. Will be applied to the sprite's `position.x`
- __Vertical Offset__ Not supported. Will be applied to the sprite's `position.y`
- __Image__ Not supported. Will be loaded as an [`SKTexture`](https://developer.apple.com/documentation/spritekit/sktexture)

### Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties will be added to the  [`SKSpriteNode`](https://developer.apple.com/documentation/spritekit/skspritenode) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type (see [Properties](Properties.md)). 
