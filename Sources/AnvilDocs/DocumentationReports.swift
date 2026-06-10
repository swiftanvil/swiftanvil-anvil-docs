import Foundation

public struct DocumentationCompositionResult: Equatable, Sendable {
    public var documentID: String
    public var outputURL: URL
    public var sourceCount: Int

    public init(documentID: String, outputURL: URL, sourceCount: Int) {
        self.documentID = documentID
        self.outputURL = outputURL
        self.sourceCount = sourceCount
    }
}

public struct DocumentationValidationReport: Equatable, Sendable {
    public var missingSources: [MissingSource]

    public init(missingSources: [MissingSource]) {
        self.missingSources = missingSources
    }

    public var isValid: Bool {
        missingSources.isEmpty
    }
}

public extension DocumentationValidationReport {
    struct MissingSource: Equatable, Sendable {
        public var documentID: String
        public var source: String

        public init(documentID: String, source: String) {
            self.documentID = documentID
            self.source = source
        }
    }
}
