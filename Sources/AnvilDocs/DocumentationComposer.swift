import Foundation
import Yams

/// Composes documentation files from a registry of stable document entries.
public struct DocumentationComposer: Sendable {
    private let fileSystem: any DocumentationFileSystem

    public init(fileSystem: any DocumentationFileSystem = LocalDocumentationFileSystem()) {
        self.fileSystem = fileSystem
    }

    /// Loads a registry from disk.
    public func loadRegistry(at registryURL: URL) throws -> DocumentationRegistry {
        let data = try fileSystem.readData(at: registryURL)
        return try YAMLDecoder().decode(DocumentationRegistry.self, from: data)
    }

    /// Validates that all source fragments referenced by a registry exist.
    public func validate(
        registry: DocumentationRegistry,
        sourceRoot: URL
    ) throws -> DocumentationValidationReport {
        var missingSources: [DocumentationValidationReport.MissingSource] = []

        for documentID in registry.documents.keys.sorted() {
            guard let document = registry.documents[documentID] else { continue }
            for source in document.sources {
                let sourceURL = sourceRoot.appending(path: source)
                if !fileSystem.fileExists(at: sourceURL) {
                    missingSources.append(.init(documentID: documentID, source: source))
                }
            }
        }

        return DocumentationValidationReport(missingSources: missingSources)
    }

    /// Composes every document in the registry.
    public func composeAll(
        registry: DocumentationRegistry,
        sourceRoot: URL,
        outputRoot: URL
    ) throws -> [DocumentationCompositionResult] {
        try registry.documents.keys.sorted().map { documentID in
            guard let document = registry.documents[documentID] else {
                throw DocumentationError.documentNotFound(documentID)
            }

            return try compose(
                documentID: documentID,
                document: document,
                sourceRoot: sourceRoot,
                outputRoot: outputRoot
            )
        }
    }

    /// Composes one document by stable document ID.
    public func compose(
        documentID: String,
        registry: DocumentationRegistry,
        sourceRoot: URL,
        outputRoot: URL
    ) throws -> DocumentationCompositionResult {
        guard let document = registry.documents[documentID] else {
            throw DocumentationError.documentNotFound(documentID)
        }

        return try compose(
            documentID: documentID,
            document: document,
            sourceRoot: sourceRoot,
            outputRoot: outputRoot
        )
    }

    private func compose(
        documentID: String,
        document: DocumentationRegistry.Document,
        sourceRoot: URL,
        outputRoot: URL
    ) throws -> DocumentationCompositionResult {
        let parts = try document.sources.map { source in
            let sourceURL = sourceRoot.appending(path: source)
            guard fileSystem.fileExists(at: sourceURL) else {
                throw DocumentationError.missingSource(documentID: documentID, source: source)
            }
            return try fileSystem.readString(at: sourceURL)
        }

        let content = parts.joined(separator: "\n\n")
        let outputURL = outputRoot.appending(path: document.path)
        try fileSystem.writeString(content, to: outputURL)

        return DocumentationCompositionResult(
            documentID: documentID,
            outputURL: outputURL,
            sourceCount: document.sources.count
        )
    }
}
