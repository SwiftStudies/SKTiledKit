#  Properties

All types of properties are supported, but the following should be noted about some types 

 - __Object__ At the moment just the `id` of the object is captured (as an `Int`) in future methods may be added to build an index of these so that the resultant SpriteKit can be accessed directly
 - __Color__ When added to [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) for a created node it will be converted into an [`SKColor`](https://developer.apple.com/documentation/spritekit/skcolor), if you are reading it directly at any point it is captured in a `TiledKit.Color` object, which has a `.skColor` property if you wish to manually convert it. 
 - __File__ These are just treated as `String`s with no special processing

