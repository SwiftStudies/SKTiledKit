#  Maps

Everything except infinite maps are supported at this point (support for Tiled features is really driven by TiledKit, so if you would like support for infinite maps
please open an enhancement issue there). 

## Support for standard Tiled Properties

 - __Orientation__ Supported
 - __Tile Width__ Supported
 - __Tile Height__ Supported
 - __Infinite__ Not supported
 - __Tile Side Hex__ Support 
 - __Stagger Axis__ Supported
 - __Tile Layer Format__ Supported 
 - __Compression Level__ Supported
 - __Background Color__ Not supported

## Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the loaded [`SKScene`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type. 

### See also

 - [Properties](Properties.md)

