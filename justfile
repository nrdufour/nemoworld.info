# Justfile for nemoworld.info blog
# Usage: just <command> [args]

# Default recipe - list available commands
default:
    @just --list

# Start Hugo dev server
serve:
    hugo server -D

# Build the site
build:
    hugo build

# Create a new blog post and open in VSCode
# Usage: just post "My Post Title"
post title:
    #!/usr/bin/env bash
    set -euo pipefail
    title="{{ title }}"
    date_prefix=$(date +%Y-%m-%d)
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    filename="content/posts/${date_prefix}-${slug}.md"
    hugo new "posts/${date_prefix}-${slug}.md"
    # Fix the title (remove date prefix that Hugo adds)
    sed -i "s/^title: .*/title: \"$title\"/" "$filename"
    # Clean up the archetype boilerplate
    sed -i '/^Lorem ipsum/d' "$filename"
    sed -i '/^<!--more-->/d' "$filename"
    sed -i '/^Cras eget metus/d' "$filename"
    # Remove multiple blank lines at end
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$filename"
    echo "Created: $filename"
    code "$filename"

# Create a new TIL (Today I Learned) entry and open in VSCode
# Usage: just til "What I learned today"
til title:
    #!/usr/bin/env bash
    set -euo pipefail
    title="{{ title }}"
    date_prefix=$(date +%Y-%m-%d)
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    filename="content/til/${date_prefix}-${slug}.md"
    hugo new "til/${date_prefix}-${slug}.md"
    # Fix the title (remove date prefix that Hugo adds)
    sed -i "s/^title: .*/title: \"$title\"/" "$filename"
    echo "Created: $filename"
    code "$filename"

# Create a new note and open in VSCode
# Usage: just note "esp32" "GPIO Pin Guide"
note topic title:
    #!/usr/bin/env bash
    set -euo pipefail
    title="{{ title }}"
    topic="{{ topic }}"
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    topic_slug=$(echo "$topic" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    mkdir -p "content/notes/${topic_slug}"
    filename="content/notes/${topic_slug}/${slug}.md"
    actual_date=$(date -Iseconds)
    printf '%s\n' "---" "title: \"$title\"" "date: $actual_date" "topics:" "- $topic" "---" "" > "$filename"
    echo "Created: $filename"
    code "$filename"

# Create a new project and open in VSCode
# Usage: just project "My Cool Project"
project title:
    #!/usr/bin/env bash
    set -euo pipefail
    title="{{ title }}"
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    filename="content/projects/${slug}.md"
    hugo new "projects/${slug}.md"
    # Fix the title
    sed -i "s/^title: .*/title: \"$title\"/" "$filename"
    echo "Created: $filename"
    code "$filename"

# Create a new recipe and open in VSCode
# Usage: just recipe "Chocolate Cake"
recipe title:
    #!/usr/bin/env bash
    set -euo pipefail
    title="{{ title }}"
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    filename="content/recipes/${slug}.md"
    hugo new "recipes/${slug}.md"
    # Fix the title
    sed -i "s/^title: .*/title: \"$title\"/" "$filename"
    echo "Created: $filename"
    code "$filename"
