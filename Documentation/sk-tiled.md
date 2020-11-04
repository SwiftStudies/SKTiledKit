#  sk-tiled

## Commands

The following commands are available 

 - [run](#run) runs a map _default command_
 - [install](#install) installs `sk-tiled` command in the default location for macOS
 - [project](#project) Opens a project, supports sub-command shown below
   - [skobjects](#skobjects) Creates/updates the object types file for the project to support all of the different SpriteKit object definitions that SKTiledKit supports 

### run (default)

This useful command enables you to load (using default SKTiledKit behavior) the specified level. You can use it to configure a command in Tiled so that you can quickly test a level you are creating. You can configure the command (in Tiled _File->Commands->Edit Commands..._) in the following way (note it assumed here you have used the `install` command to copy sk-tiled to `/usr/local/bin/`

 - __Executable__ `/usr/local/bin/sk-tiled`
 - __Arguments__ `%mapfile`
 - __Shortcut__ _Command-Shift-R_ (Recommended, but not required))
 - __Show output in Console View__ _Checked_ (Recommended, but not required))
 - __Save map before executing__ _Checked_

#### Arguments

- __level__ The path/file of the map to load and run

#### Options

##### --window-size [-w]
Allows you to specify the size of the window that is opened (by default it will open a window of the same size as the level or camera view port(see [SKCamera](SKCamera.md))

    sk-tiled run mylevel.tmx -w 1024x768
            
#### Flags

None yet

### project

Hosts a family of sub-commands that perform operations on a project

#### Arguments

 - __path__ The path to the `.tile-project` file of the project

#### Sub-commands

##### skobjects

Updates the project's referenced object types file with the various SKObject definitions. User created definitions will not be altered, but any existing `SKxxxxx` objects will be updated to 
match the latest definition

### install
Copies the executable (after building) to the specified path

#### Options

#### --path[-p]
Defaults to /usr/local/bin/

