#!/usr/bin/env xcrun swift

import Foundation

let templateProjectName = "LianSwiftTemplateProject"
let templateBundleDomain = "LianSwiftOrganizationIdentifier"

var projectName = "MyProject"
var bundleDomain = "com.test"

let fileManager = FileManager.default

let runScriptPathURL = NSURL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
let currentScriptPathURL = NSURL(fileURLWithPath: NSURL(fileURLWithPath: CommandLine.arguments[0], relativeTo: runScriptPathURL as URL).deletingLastPathComponent!.path, isDirectory: true)
let iOSProjectTemplateForlderURL = NSURL(fileURLWithPath: "DefaultTemplate", relativeTo: currentScriptPathURL as URL)
var newProjectFolderPath = ""
let ignoredFiles = [".DS_Store", "UserInterfaceState.xcuserstate"]

extension NSURL {
    var fileName: String {
        var fileName: AnyObject?
        try! getResourceValue(&fileName, forKey: URLResourceKey.nameKey)
        return fileName as! String
    }
    
    var isDirectory: Bool {
        var isDirectory: AnyObject?
        try! getResourceValue(&isDirectory, forKey: URLResourceKey.isDirectoryKey)
        return isDirectory as! Bool
    }
    
    func renameIfNeeded() {
        if let _ = fileName.range(of: templateProjectName) {
            let renamedFileName = fileName.replacingOccurrences(of: templateProjectName, with: projectName)
            try! FileManager.default.moveItem(at: self as URL, to: NSURL(fileURLWithPath: renamedFileName, relativeTo: deletingLastPathComponent) as URL)
        }
    }
    
    func updateContent() {
        guard let path = path, let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            print("ERROR READING: \(self)")
            return
        }
        var newContent = content.replacingOccurrences(of: templateProjectName, with: projectName)
        newContent = newContent.replacingOccurrences(of: templateBundleDomain, with: bundleDomain)
        try! newContent.write(to: self as URL, atomically: true, encoding: String.Encoding.utf8)
    }
}

func printInfo<T>(message: T)  {
  print("\n-------------------Info:-------------------------")
  print("\(message)")
  print("--------------------------------------------------\n")
}

func printErrorAndExit<T>(message: T) {
  print("\n-------------------Error:-------------------------")
  print("\(message)")
  print("--------------------------------------------------\n")
  exit(1)
}

func checkThatProjectForlderCanBeCreated(projectURL: NSURL){
    var isDirectory: ObjCBool = true
    if fileManager.fileExists(atPath: projectURL.path!, isDirectory: &isDirectory){
        printErrorAndExit(message: "\(projectName) \(isDirectory.boolValue ? "folder already" : "file") exists in \(runScriptPathURL.path) directory, please delete it and try again")
    }
}

func shell(args: String...) -> (output: String, exitCode: Int32) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.currentDirectoryPath = newProjectFolderPath
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String ?? ""
    return (output, task.terminationStatus)
}

func prompt(message: String, defaultValue: String) -> String {
  print("\n> \(message) (or press Enter to use \(defaultValue))")
  let line = readLine()
  return line == nil || line == "" ? defaultValue : line!
}

print("\nLet's go over some question to create your base project code!")

projectName = prompt(message: "Project name", defaultValue: projectName)
print(projectName)

// Check if folder already exists
let newProjectFolderURL = NSURL(fileURLWithPath: projectName, relativeTo: runScriptPathURL as URL)
newProjectFolderPath = newProjectFolderURL.path!
checkThatProjectForlderCanBeCreated(projectURL: newProjectFolderURL)

bundleDomain = prompt(message: "Bundle domain", defaultValue: bundleDomain)

// Copy template folder to a new folder inside run script url called projectName
do {
    try fileManager.copyItem(at: iOSProjectTemplateForlderURL as URL, to: newProjectFolderURL as URL)
} catch let error as NSError {
    printErrorAndExit(message: error.localizedDescription)
}

// rename files and update content
let enumerator = fileManager.enumerator(at: newProjectFolderURL as URL, includingPropertiesForKeys: [.nameKey, .isDirectoryKey], options: [], errorHandler: nil)!
var directories = [NSURL]()
print("\nCreating \(projectName) ...")
while let fileURL = enumerator.nextObject() as? NSURL {
    guard !ignoredFiles.contains(fileURL.fileName) else { continue }
    if fileURL.isDirectory {
      directories.append(fileURL)
    }
    else {
      fileURL.updateContent()
      fileURL.renameIfNeeded()
    }
}
for fileURL in directories.reversed() {
  fileURL.renameIfNeeded()
}

print("pod install --project-directory=\(projectName)\n")
print(shell(args: "pod", "install", "--project-directory=\(projectName)").output)
print("open \(projectName)/\(projectName).xcworkspace\n")
print(shell(args: "open", "\(projectName)/\(projectName).xcworkspace").output)
