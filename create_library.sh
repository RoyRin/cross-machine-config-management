#!/bin/bash

# Script to create a new Python library with uv
# Usage: ./create_library.sh <library_name>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <library_name>"
    echo "Example: $0 my_awesome_lib"
    exit 1
fi

LIBRARY_NAME="$1"

# Create the library directory
echo "Creating library: $LIBRARY_NAME"
mkdir -p "$LIBRARY_NAME"
cd "$LIBRARY_NAME"

# Initialize uv project
echo "Initializing uv project..."
uv init --name "$LIBRARY_NAME"

# Create directory structure
echo "Creating directory structure..."
mkdir -p notebooks
mkdir -p "$LIBRARY_NAME"

# Create exploration notebook
echo "Creating exploration notebook..."
cat > notebooks/exploration.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Exploration Notebook\n",
    "\n",
    "This notebook is for exploring ideas and prototyping code."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Add the project to path\n",
    "import sys\n",
    "sys.path.insert(0, '..')\n",
    "\n",
    "# Import your library\n",
    "# import LIBRARY_NAME"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Start exploring here\n"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "name": "python",
   "version": "3.12.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

# Update the notebook to use the actual library name
sed -i '' "s/LIBRARY_NAME/$LIBRARY_NAME/g" notebooks/exploration.ipynb

# Create __init__.py in the library directory
touch "$LIBRARY_NAME/__init__.py"

# Update pyproject.toml to include the code directory in the path
echo "Updating pyproject.toml..."
if [ -f "pyproject.toml" ]; then
    # Add the library directory to the project packages
    sed -i '' "/\[project\]/a\\
packages = [\"$LIBRARY_NAME\"]
" pyproject.toml
fi

# Create initial README
cat > README.md << EOF
# $LIBRARY_NAME

A Python library created with uv.

## Setup

\`\`\`bash
# Create virtual environment
uv venv

# Activate virtual environment
source .venv/bin/activate  # On Unix/macOS
# or
.venv\Scripts\activate  # On Windows

# Install dependencies
uv pip sync requirements.txt
\`\`\`

## Development

- Code goes in the \`$LIBRARY_NAME/\` directory
- Use \`notebooks/exploration.ipynb\` for prototyping and exploration
- Add dependencies with \`uv add <package>\`

## Structure

\`\`\`
$LIBRARY_NAME/
├── $LIBRARY_NAME/        # Main library code
├── notebooks/            # Jupyter notebooks
│   └── exploration.ipynb # For prototyping
├── pyproject.toml        # Project configuration
└── README.md            # This file
\`\`\`
EOF

echo "✅ Library '$LIBRARY_NAME' created successfully!"
echo ""
echo "Next steps:"
echo "  cd $LIBRARY_NAME"
echo "  uv venv"
echo "  source .venv/bin/activate"
echo "  uv add jupyter ipykernel  # If you want to use notebooks"
echo ""
echo "Happy coding!"