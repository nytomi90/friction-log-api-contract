# Friction Log API Contract

OpenAPI 3.0 specification for the Friction Log API - the single source of truth for backend and frontend integration.

## Overview

This repository contains the API contract that defines:
- Request/response schemas
- Endpoint definitions
- Data validation rules
- Enum values (Category, Status)

Both the backend (Python/FastAPI) and frontend (Swift/SwiftUI) generate code from this contract to ensure type safety and consistency.

## Structure

```
friction-log-api-contract/
├── spec/                   # OpenAPI specification files
│   └── openapi.yaml       # Main API spec
├── schemas/               # Schema definitions
│   ├── common.yaml        # Shared types and enums
│   ├── friction_item.yaml # FrictionItem schemas
│   └── analytics.yaml     # Analytics schemas
├── scripts/               # Code generation scripts
│   ├── generate_python.sh # Generate Pydantic models
│   └── generate_swift.sh  # Generate Swift structs
├── examples/              # Example requests/responses
└── generated/             # Generated code (git-ignored)
    ├── python/            # Pydantic models
    └── swift/             # Swift Codable structs
```

## Code Generation

### Prerequisites

**For Python generation**:
```bash
pip install datamodel-code-generator
```

**For Swift generation**:
```bash
# Install swift-openapi-generator (or CreateAPI)
brew install swift-openapi-generator
```

### Generate Code

```bash
# Generate Python Pydantic models
./scripts/generate_python.sh

# Generate Swift Codable structs
./scripts/generate_swift.sh
```

Generated code will appear in `generated/python/` and `generated/swift/` directories.

## Validation

Validate the OpenAPI spec:

```bash
# Using spectral (requires npm/node)
npm install -g @stoplight/spectral-cli
spectral lint spec/openapi.yaml
```

Or use the online validator:
- https://editor.swagger.io (paste the spec)

## Versioning

This contract follows semantic versioning:
- **MAJOR**: Breaking changes (require coordinated updates in backend and frontend)
- **MINOR**: Backward-compatible additions (new endpoints, optional fields)
- **PATCH**: Non-breaking fixes (documentation, examples)

## Usage

This repository is consumed as a git submodule by:
- `friction-log-backend` - Python FastAPI backend
- `friction-log-macos` - Swift/SwiftUI macOS app

### As a Submodule

**Add to a project**:
```bash
git submodule add https://github.com/nytomi90/friction-log-api-contract.git contract
git submodule update --init
```

**Update to latest**:
```bash
cd contract
git checkout main
git pull
cd ..
git add contract
git commit -m "chore: update API contract to vX.Y.Z"
```

## Contributing

1. Create a feature branch
2. Update the OpenAPI spec
3. Validate the spec
4. Test code generation for both Python and Swift
5. Create a PR with description of changes
6. After merge, tag a new version: `git tag vX.Y.Z`

## License

MIT
