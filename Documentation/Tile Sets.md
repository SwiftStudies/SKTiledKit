#  Tile Sets

All different types of tile sets are supported, including animation (by default an SKAction will be created to loop the animation on the created tiles) and collision objects (note collision objects are not animated, the collision objects from the first frame will be used).

 > __NB__ SpriteKit currently has a defect where shadows cast (from an `SKLightNode`) from a sub-textured sprite (such as that associated with a single image tile set) are not correctly caclulated. It is recommended that you turn any tilesets intended to work in this way into separate images. 

## Interpretted Properties

 - `filteringMode` (`String`) sets the [SKTextureFilteringMode](https://developer.apple.com/documentation/spritekit/sktexturefilteringmode) of all textures in the Tile Set. It defaults to `linear` if the property is not specified or cannot be parsed. If set to `nearest` it will use that. You can override the setting for any given tile by setting the `filteringMode` property on that Tile 

