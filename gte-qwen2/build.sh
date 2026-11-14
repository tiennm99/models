#!/bin/sh
# Build the Ollama model described by model.json from its Hugging Face upstream.
# Usage: ./build.sh [--push]
# Needs git, jq, uv and a running Ollama; --push also needs `ollama signin`.
set -eu

case "${1:-}" in
  --push) push=true ;;
  "") push=false ;;
  *) echo "usage: $0 [--push]" >&2; exit 2 ;;
esac

cd "$(dirname "$0")"
name=$(jq -r .name model.json)
upstream=$(jq -r .upstream model.json)
cache=.cache
hf_dir=$cache/hf
llama=$cache/llama.cpp
f16=$cache/gte-qwen2-1.5b-f16.gguf
fixed=$cache/gte-qwen2-1.5b-f16-fixed.gguf
mkdir -p "$cache"

echo "==> Downloading $upstream"
uvx --from huggingface_hub hf download "$upstream" --local-dir "$hf_dir"

echo "==> Fetching llama.cpp"
if [ -d "$llama/.git" ]; then
  git -C "$llama" fetch -q --depth 1 origin master
  git -C "$llama" reset -q --hard FETCH_HEAD
else
  git clone -q --depth 1 https://github.com/ggml-org/llama.cpp "$llama"
fi

# llama.cpp's converter and its matching gguf package, in a throwaway uv env.
py() {
  uv run --no-project \
    --with-requirements "$llama/requirements/requirements-convert_hf_to_gguf.txt" \
    --with "./$llama/gguf-py" \
    python "$@"
}

echo "==> Converting to F16 GGUF"
py "$llama/convert_hf_to_gguf.py" "$hf_dir" --outfile "$f16" --outtype f16

# The published model was built without these two keys; keep the build identical.
echo "==> Removing pooling_type and attention.causal metadata"
py -m gguf.scripts.gguf_new_metadata "$f16" "$fixed" --force \
  --remove-metadata qwen2.pooling_type \
  --remove-metadata qwen2.attention.causal

for tag in $(jq -r '.tags[]' model.json); do
  echo "==> Creating $name:$tag"
  ollama create "$name:$tag" -f Modelfile
  if [ "$push" = true ]; then
    echo "==> Pushing $name:$tag"
    ollama push "$name:$tag"
  fi
done
