# nemoworld.info site

This is the hugo site for the domain nemoworld.info.

Activity: 1994-present

## Publishing

The site is served by `nemosites`, a disposable NixOS box on Hetzner Cloud
defined in the avalanche repo (it also serves nicolasrdufour.info,
embryo-systems.info and souk.nemoworld.info). Publishing is a one-way push:

```bash
just publish
```

That builds with `hugo --minify` into a temp dir and rsyncs it to
`publish-nemoworld@www.nemoworld.info`, an account rrsync-locked to
`/var/www/nemoworld`. The same recipe runs in CI on every push to `main`
(`.forgejo/workflows/publish.yaml`), so a publish from a laptop and a publish
from CI cannot drift apart. The private key is a sops secret in avalanche,
rendered on calypso and on hawk's runner; the web host holds only the public
half.
