# unused/

Images pulled out of the published tree because **nothing in this repo
references them any more**: they were checked by name across every file in
every syntax (markdown, shortcodes, templates, CSS, config) and no hit came
back. They are leftovers, mostly from before the 2026 theme.

Hugo never publishes this directory - only `static/` and `themes/*/static/` are
copied into the site - and `just publish` runs rsync with `--delete`, so moving
a file here is what removes it from the live web root.

They were moved rather than deleted because it costs nothing: git stores the
content once either way, so the blob is shared with the old `static/` path, and
the working copy survives in case one of them turns out to be wanted after all.
Deleting them for good is a single commit away.

To serve one again, move it back under `static/` and reference it.
