import Foundation
import ArgumentParser

enum CoverageFormats: String {
    case cobertura
    case json
    case html
}

struct XCCIKitCov: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "xccikit-cov",
        abstract: "A Swift CLI tool to convert XCodes code coverage xcresult report to other formats"
    )

    init() { }

    @Option(name: .shortAndLong,
            help: "The 'Cobertura' coverage format")
    private var format: String?
    
    @Option(name: .shortAndLong,
            help: "The output path, if not specified output is written to stdout")
    private var outputPath: String?
    
    @Flag(help: "If provided inidcates that the bundle path is already a *.json file")
    private var isJSONBundle: Bool = false

    @Argument(help: "The path to the *.xcresult bundle, use '-' to indicate stdin")
    private var xcResultBundlePath: String
    
    @Argument(help: "The targets to include")
    private var targets: [String] = []
    
    func run() throws {
        let inputFile = xcResultBundlePath == "-" ? FileHandle.standardInput :
            try FileHandle.init(forReadingFrom: fullfileURL(xcResultBundlePath))
        
        let data =  inputFile.readDataToEndOfFile()
        print(data)

        let decoder = JSONDecoder()
        let xcresult = try decoder.decode(XCResultCov.self, from: data)
        
        xcresult.dropTargets { !targets.contains($0.name) }
        print(xcresult.targets.map {$0.name})
        
        let cob = cobertura(from: xcresult)
        
        var outputFile = FileHandle.standardOutput
        if let outputPath = outputPath, outputPath != "-" {
            let outputURL = fullfileURL(outputPath)
            print(outputURL, outputURL.absoluteURL, outputURL.path)
            if !FileManager.default.fileExists(atPath: outputURL.path) {
                let created = FileManager.default.createFile(atPath: outputURL.path,
                                               contents: nil, attributes: nil)
                print(created)
            }
            outputFile = try FileHandle.init(forWritingTo: outputURL)
        }

        cob.xmlElement.xmlString(options: .nodePrettyPrint).write(to: &outputFile)
    }
}

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.write(data)
        }
    }
}

func fullfileURL(_ filepath: String) -> URL {
    if filepath.starts(with: "/") {
        return URL(fileURLWithPath: filepath)
    }

    let path = FileManager.default.currentDirectoryPath

    //Lets prevent any directory traversal
    let filename = URL(fileURLWithPath: filepath).lastPathComponent
    let fullFilename = URL(fileURLWithPath: path).appendingPathComponent(filename)
    return fullFilename
}

XCCIKitCov.main()
