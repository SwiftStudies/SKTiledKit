#  Maps

Not all kinds of map, or standard properties of maps are supported yet. The following are supported

## Support for standard Tiled Properties

 - __Orientation__ Only `orthogonal` is currently supported
 - __Tile Width__ Supported
 - __Tile Height__ Supported
 - __Infinite__ Not supported
 - __Tile Side Hex__ Not supported 
 - __Stagger Axis__ Not supported
 - __Tile Layer Format__ Only `csv` is currently supported
 - __Compression Level__ Not supported
 - __Background Color__ Not supported

## Support for user specified properties

No special interpretation of user specified properties is done at this time, however all properties are added to the loaded [`SKScene`](https://developer.apple.com/documentation/spritekit/skscene) [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) and converted to the appropriate type. 

### See also

 - [Properties](Properties.md)

