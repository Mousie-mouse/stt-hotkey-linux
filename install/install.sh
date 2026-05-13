#!/usr/bin/env bash
set -euo pipefail

PREFIX="${HOME}/.local"
BINDIR="${PREFIX}/bin"
WHISPER_DIR="${HOME}/whisper.cpp"
WHISPER_BIN="${WHISPER_DIR}/build/bin/whisper-cli"
BASE_MODEL="${WHISPER_DIR}/models/ggml-base.en.bin"
SMALL_MODEL="${WHISPER_DIR}/models/ggml-small.en.bin"
TEST_DIR="$HOME/stt-audio-tests"
OUTPUT_DIR="$HOME/stt-output"

mkdir -p "$HOME/stt-audio-tests/audio"
mkdir -p "$HOME/stt-audio-tests/transcripts"
mkdir -p "$OUTPUT_DIR"

mkdir -p "$BINDIR"

echo "Created test directories at $TEST_DIR"
echo "Created transcript output directory at $OUTPUT_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Installing commands from $REPO_DIR/bin to $BINDIR"

for cmd in "$REPO_DIR"/bin/*; do
  if [ -f "$cmd" ]; then
    install -m 755 "$cmd" "$BINDIR/$(basename "$cmd")"
    echo "Installed: $(basename "$cmd")"
  fi
done

# Ensure ~/.local/bin is on PATH for future shells
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

if ! printf '%s' ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
  if [ -f "$HOME/.profile" ]; then
    grep -Fqx "$PATH_LINE" "$HOME/.profile" || echo "$PATH_LINE" >> "$HOME/.profile"
  else
    echo "$PATH_LINE" >> "$HOME/.profile"
  fi
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Missing dependency: git"
  exit 1
fi

if ! command -v cmake >/dev/null 2>&1; then
  echo "Missing dependency: cmake"
  exit 1
fi

if ! command -v arecord >/dev/null 2>&1; then
  echo "Missing dependency: arecord (install alsa-utils)"
  exit 1
fi


if ! command -v xclip >/dev/null 2>&1; then
  echo "Missing dependency: xclip"
  exit 1
fi

if [ ! -d "$WHISPER_DIR" ]; then
  git clone https://github.com/ggml-org/whisper.cpp "$WHISPER_DIR"
fi

if [ ! -x "$WHISPER_BIN" ]; then
  cd "$WHISPER_DIR"
  cmake -B build
  cmake --build build -j --config Release
fi

if [ ! -f "$BASE_MODEL" ]; then
  cd "$WHISPER_DIR"
  bash ./models/download-ggml-model.sh base.en
fi

if [ ! -f "$SMALL_MODEL" ]; then
  cd "$WHISPER_DIR"
  bash ./models/download-ggml-model.sh small.en
fi

# --- verification block starts here ---

echo
echo "Verifying install..."

if [ ! -x "$WHISPER_BIN" ]; then
  echo "Verification failed: whisper-cli not found at $WHISPER_BIN"
  exit 1
fi

if [ ! -f "$BASE_MODEL" ]; then
  echo "Verification failed: base model not found at $BASE_MODEL"
  exit 1
fi

if [ ! -f "$SMALL_MODEL" ]; then
  echo "Verification failed: small.en model not found at $SMALL_MODEL"
  exit 1
fi

echo "whisper-cli found: $WHISPER_BIN"
echo "base model found: $BASE_MODEL"
echo "small.en model found: $SMALL_MODEL"
echo
echo "Available capture devices:"
arecord -l || true

cat <<EOF

Install complete.

whisper-cli found: $WHISPER_BIN
base model found: $BASE_MODEL
small.en model found: $SMALL_MODEL
transcript output directory: $OUTPUT_DIR

Available capture devices:
$(arecord -l 2>/dev/null || true)

Next steps:
  1. If your mic records silence, run:
       arecord -l
       arecord -L | sed -n '1,120p'
       alsamixer
  2. Start STT:
       $HOME/.local/bin/stt

Note:
  ~/.local/bin was added to ~/.profile for future sessions.
  Open a new terminal or log out/in before using plain 'stt'.


Optional smoke test:
  $WHISPER_BIN -m $BASE_MODEL -f /path/to/test.wav -l en
  $WHISPER_BIN -m $SMALL_MODEL -f /path/to/test.wav -l en -mc 0 -tp 0 -tpi 0 -nf -ml 80 -sns

EOF
