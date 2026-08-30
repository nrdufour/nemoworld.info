# Justfile for nemoworld.info blog
# Usage: just <command> [args]

# --- Publishing -------------------------------------------------------------
# The site is served by `nemoworld`, a disposable NixOS box on Hetzner Cloud
# defined in the avalanche repo. Publishing is a one-way push from here: that
# host holds no credential of its own, so nothing ever pulls from the homelab.
# The exact same recipe runs by hand and in CI (.forgejo/workflows/publish.yaml).

# Where to publish. Override before the DNS cutover, or to reach a rebuilt
# box before its records exist:  NEMOWORLD_HOST=203.0.113.10 just publish
host := env_var_or_default("NEMOWORLD_HOST", "www.nemoworld.info")

# Private half of the dedicated publish key. A sops secret in avalanche,
# rendered by NixOS on calypso and on hawk's runner — it lives nowhere else,
# and the web host holds only the matching public key.
publish_key := env_var_or_default("NEMOWORLD_PUBLISH_KEY", "/run/secrets/nemoworld/publish_ssh_key")

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

# Build the site and push it to the public web host
publish:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -r "{{ publish_key }}" ]; then
      echo "ERROR: publish key not readable at {{ publish_key }}" >&2
      echo "       On calypso and hawk it is rendered there by sops-nix." >&2
      echo "       Elsewhere, point NEMOWORLD_PUBLISH_KEY at it." >&2
      exit 1
    fi
    out=$(mktemp -d)
    trap 'rm -rf "$out"' EXIT
    # Build to a temp dir, never ./public: a stale public/ from `hugo server`
    # would otherwise decide what the world sees.
    hugo --minify --destination "$out"

    # Normalise modes before sending. Two reasons this is not optional:
    # mktemp -d creates the directory 0700, and rsync -p would faithfully
    # reproduce that on the web root, leaving nginx unable to traverse into
    # it (403 on every page). And a build host with a restrictive umask would
    # otherwise publish unreadable files. rrsync's option allowlist rejects
    # --chmod, so the far side cannot fix this for us.
    chmod 755 "$out"
    find "$out" -type d -exec chmod 755 {} +
    find "$out" -type f -exec chmod 644 {} +

    # -rlptvc rather than -a. No -o/-g (the far side is rrsync, and everything
    # lands owned by the publish user regardless) and no -D (a static site has
    # no devices). -c is load-bearing: hugo rewrites every file on every build,
    # so the default size+mtime check would retransmit all of it every time.
    # --stats and --human-readable are deliberately absent — rrsync's option
    # allowlist rejects them and the transfer would die.
    #
    # The remote path is EMPTY, not "/": the forced command is
    # `rrsync -wo /var/www/nemoworld`, and rrsync rejects a leading slash as
    # an unsafe arg ("unsafe arg: /"). An empty path is the confined root.
    #
    # accept-new is trust-on-first-use, not blind trust: an unknown host is
    # recorded, but a host whose key has *changed* is a hard failure. The web
    # host generates its SSH key at first boot rather than baking it into the
    # snapshot, so after `just cloud destroy` + `create` its key is genuinely
    # new — drop the stale known_hosts line then, and only then.
    rsync -rlptvc --delete \
      -e "ssh -i {{ publish_key }} -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new" \
      "$out/" "publish@{{ host }}:"

    echo "published to {{ host }}"
