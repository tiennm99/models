# Models

Build logic for custom Ollama models, published on [ollama.com/miti99](https://ollama.com/miti99).

## Quick start

```sh
ollama signin                 # once per machine, needed to push
./gte-qwen2/build.sh          # build and create the model locally
./gte-qwen2/build.sh --push   # build, create and publish
```

Requirements: `git`, `jq`, [uv](https://docs.astral.sh/uv/) and a running
[Ollama](https://ollama.com/download). Downloads and build output go to each
model folder's gitignored `.cache/`.

## Where to build

Builds are heavy: they download several GB of weights and need a machine with a
strong enough GPU. Run them by hand on such a machine only. Do not build in
CI/CD or on a lightweight or shared machine, and do not add a workflow that
does.

## Model index

| Model | Tags | Upstream | Notes |
| --- | --- | --- | --- |
| [`miti99/gte-qwen2`](https://ollama.com/miti99/gte-qwen2) | `latest` | [Alibaba-NLP/gte-Qwen2-1.5B-instruct](https://huggingface.co/Alibaba-NLP/gte-Qwen2-1.5B-instruct) | Embedding model, F16. See [gte-qwen2/](gte-qwen2/README.md) |

## Layout

Each model has one folder named after the model, holding:

- `model.json`: the Ollama name, the tags it is published under, the
  Hugging Face upstream and a short description.
- `Modelfile`: the Ollama Modelfile, pointing at the GGUF the build produces.
- `build.sh`: downloads the upstream, converts it and runs `ollama create`
  for every tag, plus `ollama push` with `--push`.
- `README.md`: what was changed from upstream and how to use the model.

## License

The build logic here is under the [Apache License 2.0](LICENSE). Each model
keeps its upstream license; see its folder.
