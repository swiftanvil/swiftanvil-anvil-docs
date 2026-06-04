# AnvilDocs

Registry-driven documentation composition for SwiftAnvil packages and tools.

## Purpose

AnvilDocs turns a documentation registry into composed Markdown outputs. It is intentionally a library package first
so `swiftanvil-cli` can own command-line UX while this package owns the reusable registry, validation, and composition
logic.

## Features

- Load documentation registries from YAML.
- Validate that all referenced source fragments exist.
- Compose one document by stable document ID.
- Compose all documents deterministically.
- Write outputs atomically through Foundation.

## Usage

```swift
import AnvilDocs
import Foundation

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let composer = DocumentationComposer()
let registry = try composer.loadRegistry(at: root.appending(path: "Documentation/Registry/index.yml"))

let report = try composer.validate(
    registry: registry,
    sourceRoot: root.appending(path: "Documentation")
)

guard report.isValid else {
    throw DocumentationError.missingSource(
        documentID: report.missingSources[0].documentID,
        source: report.missingSources[0].source
    )
}

try composer.composeAll(
    registry: registry,
    sourceRoot: root.appending(path: "Documentation"),
    outputRoot: root
)
```

## Registry Shape

```yaml
documents:
  guide:
    title: Guide
    path: Composed/guide.md
    sources:
      - Fragments/intro.md
      - Fragments/usage.md
```

`path` is relative to the output root. Each source is relative to the source root.

## Architecture

```text
AnvilDocs
├── DocumentationComposer.swift
├── DocumentationRegistry.swift
├── DocumentationReports.swift
├── DocumentationError.swift
└── DocumentationFileSystem.swift
```

The package keeps process execution and CLI argument parsing out of the library. DocC command integration belongs in
a later child once registry composition is stable.

## Requirements

- Swift 6
- macOS 13+

## Dependencies

- Yams for YAML decoding.
