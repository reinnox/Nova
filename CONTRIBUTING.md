# Contributing

Thanks for contributing to Nova. Please follow these guidelines:
- Follow the module layout in MODULES.md.
- Include Luau type annotations for all public APIs.
- Put tunable values in `ReplicatedStorage/Shared/DataModules`.
- Write unit-test placeholders in `tests/` for new services.
- Use EventBus for cross-service interaction and avoid direct circular dependencies.
- New features should come with a CHANGELOG entry and updated BALANCING.md if they affect gameplay.

Please see CODE_OF_CONDUCT.md for community guidelines.
