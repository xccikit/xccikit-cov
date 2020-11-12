//
//  XCResultCovTarget.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/12/20.
//

class XCResultCovTarget: XCResultCovCommon {
    let name: String
    let buildProductPath: String
    let files: [XCResultCovFile]
    
    enum CodingKeys: String, CodingKey {
        case name, buildProductPath, files
    }
    
    internal init(coveredLines: UInt, lineCoverage: Double, executableLines: UInt,
                  name: String, buildProductPath: String, files: [XCResultCovFile]) {
        self.name = name
        self.buildProductPath = buildProductPath
        self.files = files

        super.init(coveredLines: coveredLines, lineCoverage: lineCoverage, executableLines: executableLines)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        buildProductPath = try container.decode(String.self, forKey: .buildProductPath)
        files = try container.decode([XCResultCovFile].self, forKey: .files)
        try super.init(from: decoder)
    }
}
