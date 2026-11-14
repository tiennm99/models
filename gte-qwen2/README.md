# gte-qwen2

Alibaba's [gte-Qwen2-1.5B-instruct](https://huggingface.co/Alibaba-NLP/gte-Qwen2-1.5B-instruct)
text embedding model, converted to F16 GGUF for Ollama as
[`miti99/gte-qwen2`](https://ollama.com/miti99/gte-qwen2).

## Use

```sh
ollama pull miti99/gte-qwen2
curl http://localhost:11434/api/embed -d '{"model": "miti99/gte-qwen2", "input": "Hello world"}'
```

## Build

```sh
./build.sh          # build and create miti99/gte-qwen2:latest locally
./build.sh --push   # also publish it (needs `ollama signin`)
```

Steps, all in [`build.sh`](build.sh):

1. Download the upstream weights with the Hugging Face CLI.
2. Convert them to F16 GGUF with llama.cpp's `convert_hf_to_gguf.py`.
3. Remove the `qwen2.pooling_type` and `qwen2.attention.causal` metadata keys
   with `gguf_new_metadata`.
4. Create the model from the [`Modelfile`](Modelfile), which sets
   `num_ctx` to 8192.

The conversion installs PyTorch (CPU build) into a temporary uv environment and
downloads several GB of weights.

## License

The model weights are under the upstream's
[Apache License 2.0](https://huggingface.co/Alibaba-NLP/gte-Qwen2-1.5B-instruct).

## Credits

- https://huggingface.co/Alibaba-NLP/gte-Qwen2-1.5B-instruct
- https://github.com/ggml-org/llama.cpp
