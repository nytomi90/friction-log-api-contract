#!/bin/bash

# Generate Python Pydantic models from OpenAPI specification
# Requirements: datamodel-code-generator
# Install: pip install datamodel-code-generator[http]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Generating Python Pydantic models from OpenAPI spec...${NC}"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if datamodel-code-generator is installed
if ! python -m datamodel_code_generator --help &> /dev/null; then
    echo "Error: datamodel-code-generator not found"
    echo "Install it with: pip install datamodel-code-generator[http]"
    exit 1
fi

# Create output directory
OUTPUT_DIR="$PROJECT_ROOT/generated/python"
mkdir -p "$OUTPUT_DIR"

# Generate models
echo "Generating from spec/openapi.yaml..."
python -m datamodel_code_generator \
    --input "$PROJECT_ROOT/spec/openapi.yaml" \
    --input-file-type openapi \
    --output "$OUTPUT_DIR/models.py" \
    --output-model-type pydantic_v2.BaseModel \
    --use-standard-collections \
    --use-schema-description \
    --use-title-as-name \
    --field-constraints \
    --snake-case-field \
    --target-python-version 3.11 \
    --openapi-scopes paths schemas \
    --use-annotated

# Create __init__.py for easy imports
cat > "$OUTPUT_DIR/__init__.py" << 'EOF'
"""
Generated Pydantic models from Friction Log API contract.
DO NOT EDIT - this file is auto-generated.
Regenerate with: ./scripts/generate_python.sh
"""

from .models import *

__all__ = [
    # Enums
    'Category',
    'Status',

    # Friction Item schemas
    'FrictionItemCreate',
    'FrictionItemUpdate',
    'FrictionItemResponse',

    # Analytics schemas
    'CurrentScore',
    'TrendDataPoint',
    'CategoryBreakdown',

    # Common schemas
    'ErrorResponse',
]
EOF

echo -e "${GREEN}✓ Python models generated successfully${NC}"
echo "Output: $OUTPUT_DIR/models.py"
echo ""
echo "To use in your Python code:"
echo "  from contract.generated.python import FrictionItemCreate, Category, Status"
