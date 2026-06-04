# AnvilDocs Roadmap

> Current version: unreleased | PMS: not scored | Next review: after initial release

---

## Now — Active

- [ ] **DOC-001**: Initial package release with registry load, validate, and compose APIs.
- [ ] **DOC-002**: Integrate with `swiftanvil-cli` as `swiftanvil docs compose`.
- [ ] **DOC-003**: Decide DocC ownership: wrapper in this package, CLI command, or separate future child.

## Next — Planned

- [ ] Template-based landing page generation using AnvilTemplate.
- [ ] Integration tests against representative registry fixtures.
- [ ] Diagnostics with file paths, document IDs, and source ordering.

## Later — Future

- [ ] Optional DocC archive generation.
- [ ] Static hosting transforms.
- [ ] Broken-link checks for composed Markdown and generated DocC output.

---

## Decision

AnvilDocs is a separate package. It owns reusable documentation registry logic, while `swiftanvil-cli` should own the
command-line experience that calls into this library.
