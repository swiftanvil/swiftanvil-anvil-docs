import Foundation

public protocol DocumentationFileSystem: Sendable {
    func fileExists(at url: URL) -> Bool
    func readData(at url: URL) throws -> Data
    func readString(at url: URL) throws -> String
    func writeString(_ string: String, to url: URL) throws
}

public struct LocalDocumentationFileSystem: DocumentationFileSystem {
    public init() { }

    public func fileExists(at url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }

    public func readData(at url: URL) throws -> Data {
        try Data(contentsOf: url)
    }

    public func readString(at url: URL) throws -> String {
        try String(contentsOf: url, encoding: .utf8)
    }

    public func writeString(_ string: String, to url: URL) throws {
        let directory = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try string.write(to: url, atomically: true, encoding: .utf8)
    }
}
