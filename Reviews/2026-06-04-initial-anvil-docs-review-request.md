# Review Request: Initial AnvilDocs Package

## Intention

Review the initial `swiftanvil-anvil-docs` package. The organization decided Child 3.4 should be a separate package,
not code folded directly into `swiftanvil-cli`.

This initial package intentionally owns reusable registry composition logic only. CLI command UX and DocC process
execution should remain later integration work.

## Builder

Codex.

## Reviewer Ask

Please review:

1. Package boundary: reusable library package, CLI integration later.
2. Public API design:
   - `DocumentationComposer`
   - `DocumentationRegistry`
   - `DocumentationValidationReport`
   - `DocumentationCompositionResult`
   - `DocumentationError`
   - `DocumentationFileSystem`
3. Swift 6 concurrency correctness and `Sendable` usage.
4. Test coverage for registry loading, validation, composition, deterministic ordering, and error paths.
5. Whether the package is honest about being an initial registry composer rather than a full DocC generator.
6. CI and enforcement setup.

## Expected Output

Return one of:

- APPROVED
- APPROVED_WITH_NOTES
- NEEDS_REVISION

Lead with the verdict, then list findings by severity. Focus on blocking correctness issues first.
