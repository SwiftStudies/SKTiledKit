//    Copyright 2020 Swift Studies
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

import Foundation
import ArgumentParser

struct ProjectCommand : ParsableCommand {
    static var configuration =  CommandConfiguration(commandName:"project", abstract:"Opens a project so that you can perform a range of sub-commands on that project", subcommands: [CreateSpriteKitObjectTypes.self])
    
    struct Options : ParsableArguments {
        @Argument(help: "The location of an .tiled-project file, or the location of where you would like to create it if it does not exist")
        var path : String
    }
    
    
}
