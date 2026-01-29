#!/bin/bash

# Generate Swift Codable models from OpenAPI specification
# Requirements: swift-openapi-generator or CreateAPI
# Install: brew install swift-openapi-generator

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Generating Swift Codable models from OpenAPI spec...${NC}"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Create output directory
OUTPUT_DIR="$PROJECT_ROOT/generated/swift"
mkdir -p "$OUTPUT_DIR"

# Check if swift-openapi-generator is available
if command -v swift-openapi-generator &> /dev/null; then
    echo "Using swift-openapi-generator..."

    # Create config file
    cat > "$PROJECT_ROOT/openapi-generator-config.yaml" << 'EOF'
generate:
  - types
  - client
accessModifier: public
EOF

    swift-openapi-generator generate \
        --mode types \
        --output-directory "$OUTPUT_DIR" \
        "$PROJECT_ROOT/spec/openapi.yaml"

    echo -e "${GREEN}✓ Swift models generated successfully${NC}"
    echo "Output: $OUTPUT_DIR"

elif command -v create-api &> /dev/null; then
    echo "Using CreateAPI..."

    create-api generate \
        "$PROJECT_ROOT/spec/openapi.yaml" \
        --output "$OUTPUT_DIR" \
        --config-option "module=FrictionLogAPI"

    echo -e "${GREEN}✓ Swift models generated successfully${NC}"
    echo "Output: $OUTPUT_DIR"

else
    echo -e "${RED}Error: No Swift OpenAPI generator found${NC}"
    echo ""
    echo "Please install one of the following:"
    echo ""
    echo "1. swift-openapi-generator (recommended):"
    echo "   brew install swift-openapi-generator"
    echo ""
    echo "2. CreateAPI:"
    echo "   brew install create-api"
    echo ""
    echo "Or manually create Swift Codable structs matching the OpenAPI spec."
    exit 1
fi

echo ""
echo "To use in your Xcode project:"
echo "1. Add generated Swift files to your Xcode project"
echo "2. Choose 'Create folder references' (not groups)"
echo "3. Import the generated types in your code"
