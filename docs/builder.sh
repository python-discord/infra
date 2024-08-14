#!/bin/sh

# Ensure Poetry is accessible in the current session
export PATH=“/opt/render/project/poetry/bin:$PATH”

# Check for Poetry, and install it if not found
if ! command -v poetry &> /dev/null; then
    echo “Poetry not found. Installing Poetry...”
    curl -sSL https://install.python-poetry.org | python3 -
    # Add Poetry to PATH for the current session
    export PATH=“$HOME/.local/bin:$PATH”
else
    echo “Poetry found: $(poetry --version)”
fi

# Check that Poetry was successfully installed and is working
poetry --version

if [ $? -ne 0 ]; then
    echo “Poetry installation failed.”
    exit 1
fi

# Install dependencies using Poetry
echo “Running poetry install...”

poetry install --with docs

# Run the build process for mkdocs
echo “Running build process with Yarn...”

poetry run mkdocs build
