# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-06-04

### Added

- `DocumentationRegistry` — stable document ID to composed document mapping with Codable/Equatable/Sendable conformance.
- `DocumentationComposer` — load registry from YAML, validate source fragments, compose one or all documents deterministically.
- `DocumentationFileSystem` protocol — injectable for testing, with `LocalDocumentationFileSystem` atomic-write implementation.
- `DocumentationError` — typed errors for missing documents and missing sources.
- `DocumentationCompositionResult` and `DocumentationValidationReport` — structured output types.
- 6 Swift Testing tests covering registry load, composition, validation, and error paths.
- Swift 6 + StrictConcurrency throughout.
- CI workflow via GitHub Actions on macOS 15.

[0.1.0]: https://github.com/swiftanvil/swiftanvil-anvil-docs/releases/tag/0.1.0
