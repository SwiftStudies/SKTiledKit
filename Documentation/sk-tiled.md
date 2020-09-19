#  sk-tiled

## Commands

### install

#### Arguments

### run (default)

This useful command enables you to load (using default SKTiledKit behavior) the specified level. You can use it to configure a command in Tiled so that you can quickly test a level you are creating. You can configure the command (in Tiled _File->Commands->Edit Commands..._) in the following way (note it assumed here you have used the `install` command to copy sk-tiled to `/usr/local/bin/`

 - __Executable__ `/usr/local/bin/sk-tiled`
 - __Arguments__ `%mapfile`
 - __Shortcut__ _Command-Shift-R_ (Recommended, but not required))
 - __Show output in Console View__ _Checked_ (Recommended, but not required))
 - __Save map before executing__ _Checked_

#### Arguments

##### Level File
The level to load, for example

            sk-tiled mylevel.tmx

#### Options

##### --window-size [-w]

Specified in the form <width>x<height> you can override the default window size (which is the size of the level), for example

            sk-tiled run mylevel.tmx -w 1024x768
            
#### Flags

None yet
