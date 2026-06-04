import Foundation

/// Errors thrown while loading, validating, or composing documentation.
public enum DocumentationError: Error, Equatable, Sendable {
    case documentNotFound(String)
    case missingSource(documentID: String, source: String)
}
