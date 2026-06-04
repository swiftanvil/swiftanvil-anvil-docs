import Foundation

/// A registry that maps stable document IDs to composed document definitions.
public struct DocumentationRegistry: Codable, Equatable, Sendable {
    public var documents: [String: Document]

    public init(documents: [String: Document]) {
        self.documents = documents
    }
}

extension DocumentationRegistry {
    public struct Document: Codable, Equatable, Sendable {
        public var title: String?
        public var path: String
        public var sources: [String]

        public init(title: String? = nil, path: String, sources: [String]) {
            self.title = title
            self.path = path
            self.sources = sources
        }
    }
}
