import Foundation
import Testing
@testable import AnvilDocs

@Suite("DocumentationComposer")
struct DocumentationComposerTests {
    @Test("loads registry from YAML")
    func loadsRegistryFromYAML() throws {
        let root = try TemporaryDirectory()
        let registryURL = root.url.appending(path: "Documentation/Registry/index.yml")
        try root.write(
            """
            documents:
              readme:
                title: README
                path: Composed/README.md
                sources:
                  - Fragments/intro.md
            """,
            to: registryURL
        )

        let registry = try DocumentationComposer().loadRegistry(at: registryURL)

        #expect(registry.documents["readme"]?.title == "README")
        #expect(registry.documents["readme"]?.path == "Composed/README.md")
        #expect(registry.documents["readme"]?.sources == ["Fragments/intro.md"])
    }

    @Test("composes one document from fragments")
    func composesOneDocument() throws {
        let root = try TemporaryDirectory()
        let sourceRoot = root.url.appending(path: "Documentation")
        let outputRoot = root.url
        try root.write("# Intro", to: sourceRoot.appending(path: "Fragments/intro.md"))
        try root.write("Details", to: sourceRoot.appending(path: "Fragments/details.md"))

        let registry = DocumentationRegistry(documents: [
            "readme": .init(
                title: "README",
                path: "Composed/README.md",
                sources: ["Fragments/intro.md", "Fragments/details.md"]
            ),
        ])

        let result = try DocumentationComposer().compose(
            documentID: "readme",
            registry: registry,
            sourceRoot: sourceRoot,
            outputRoot: outputRoot
        )

        #expect(result.documentID == "readme")
        #expect(result.sourceCount == 2)
        #expect(try root.read(outputRoot.appending(path: "Composed/README.md")) == "# Intro\n\nDetails")
    }

    @Test("compose all is deterministic by document ID")
    func composeAllIsDeterministic() throws {
        let root = try TemporaryDirectory()
        let sourceRoot = root.url.appending(path: "Documentation")
        let outputRoot = root.url
        try root.write("A", to: sourceRoot.appending(path: "Fragments/a.md"))
        try root.write("B", to: sourceRoot.appending(path: "Fragments/b.md"))

        let registry = DocumentationRegistry(documents: [
            "b": .init(path: "Composed/B.md", sources: ["Fragments/b.md"]),
            "a": .init(path: "Composed/A.md", sources: ["Fragments/a.md"]),
        ])

        let results = try DocumentationComposer().composeAll(
            registry: registry,
            sourceRoot: sourceRoot,
            outputRoot: outputRoot
        )

        #expect(results.map(\.documentID) == ["a", "b"])
    }

    @Test("validation reports missing sources")
    func validationReportsMissingSources() throws {
        let root = try TemporaryDirectory()
        let sourceRoot = root.url.appending(path: "Documentation")
        try root.write("A", to: sourceRoot.appending(path: "Fragments/a.md"))

        let registry = DocumentationRegistry(documents: [
            "readme": .init(path: "Composed/README.md", sources: ["Fragments/a.md", "Fragments/missing.md"]),
        ])

        let report = try DocumentationComposer().validate(registry: registry, sourceRoot: sourceRoot)

        #expect(report.isValid == false)
        #expect(report.missingSources == [.init(documentID: "readme", source: "Fragments/missing.md")])
    }

    @Test("throws for unknown document ID")
    func throwsForUnknownDocumentID() throws {
        let root = try TemporaryDirectory()
        let registry = DocumentationRegistry(documents: [:])

        #expect(throws: DocumentationError.documentNotFound("missing")) {
            _ = try DocumentationComposer().compose(
                documentID: "missing",
                registry: registry,
                sourceRoot: root.url,
                outputRoot: root.url
            )
        }
    }

    @Test("throws when composing missing source")
    func throwsForMissingSource() throws {
        let root = try TemporaryDirectory()
        let registry = DocumentationRegistry(documents: [
            "readme": .init(path: "Composed/README.md", sources: ["missing.md"]),
        ])

        #expect(throws: DocumentationError.missingSource(documentID: "readme", source: "missing.md")) {
            _ = try DocumentationComposer().compose(
                documentID: "readme",
                registry: registry,
                sourceRoot: root.url,
                outputRoot: root.url
            )
        }
    }
}
