//
//  XCResultCovFile.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/12/20.
//

//{
//   "coveredLines": 0,
//   "lineCoverage": 0,
//   "path": "/Users/tristian/Repos/github.com/AirspaceTechnologies/DriverAppiOS/DriverApp/Pods/JCTagListView/Pod/Classes/JCTagListView.m",
//   "functions": [
class XCResultCovFile: XCResultCovCommon {
    let path: String
    let name: String
    let functions: [XCResultCovFunction]

    internal init(coveredLines: UInt, lineCoverage: Double, executableLines: UInt,
                  name: String, path: String, functions: [XCResultCovFunction]) {
        self.name = name
        self.path = path
        self.functions = functions

        super.init(coveredLines: coveredLines, lineCoverage: lineCoverage, executableLines: executableLines)
    }

    enum CodingKeys: String, CodingKey {
        case path, functions, name
    }

    required init(from decoder: Decoder) throws {
        let cntr = try decoder.container(keyedBy: CodingKeys.self)
        name = try cntr.decode(String.self, forKey: .name)
        path = try cntr.decode(String.self, forKey: .path)
        functions = try cntr.decode([XCResultCovFunction].self, forKey: .functions)
        try super.init(from: decoder)
    }
}
