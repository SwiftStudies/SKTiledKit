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

import ArgumentParser

struct SKTiled : ParsableCommand {
    static var configuration =  CommandConfiguration(abstract:"Enables direct testing of levels and compilation of Tile Sets into XCode assets",subcommands: [Install.self, Run.self, ProjectCommand.self], defaultSubcommand: Run.self)
    
}
