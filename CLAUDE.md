# CLAUDE.md

Build logic for custom Ollama models; see [README.md](README.md).

- Never run a model's `build.sh`, and never add CI/CD that builds or pushes
  models. Builds are too heavy for agent machines and CI runners; the user runs
  them by hand on a machine with a strong enough GPU. Check changes with
  `shellcheck` and by reading the upstream tools' source instead.
- A new model gets its own folder with `model.json`, `Modelfile`, `build.sh` and
  `README.md`, and a row in the README's model index.
