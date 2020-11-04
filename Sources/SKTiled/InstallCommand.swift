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

struct Install : ParsableCommand {
    static var configuration =  CommandConfiguration(abstract:"Copies the binary to a specified location or /usr/local/bin if no location specified")
    
    @Option(name:.shortAndLong, help:"Location to install the command in. Default is /usr/local/bin/sktiled")
    var path : String?
    static let defaultPath = "/usr/local/bin"
    static let executableName = "sktiled"

    func run() throws {
        let source = CommandLine.arguments[0]
        var destination = path ?? Self.defaultPath
        
        destination = destination.hasSuffix("/") ? "\(destination)\(Self.executableName)" : "\(destination)/\(Self.executableName)"
        
        print("Installing \(Self.executableName) in \(path ?? Self.defaultPath)")
        print( "\t\(bash(command: "cp", arguments: ["-v",source,destination]))" )
    }
}
