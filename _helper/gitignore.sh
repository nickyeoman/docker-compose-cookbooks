#!/bin/bash

# Function to create a .gitignore file with standard ignores
create_gitignore() {
    local project_path="$1"
    local gitignore_path="$project_path/.gitignore"

    # Create the .gitignore file
    cat <<EOL > "$gitignore_path"
data/
logs/
*.log
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
.DS_Store
Thumbs.db
EOL
}
