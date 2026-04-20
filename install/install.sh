#!/usr/bin/env bash
set -euo pipefail

PREFIX="${HOME}/.local"
BINDIR="${PREFIX}/bin"
WHISPER_DIR="${HOME}/whisper.cpp"
WHISPER_BIN="${WHISPER_DIR}/build/bin/whisper-cli"
BASE_MODEL="${WHISPER_DIR}/models/ggml-base.en.bin"

mkdir -p "$BINDIR"

install -m 755 "$(dirname "$0")/../bin/stt" "$BINDIR/stt"
install -m 755 "$(dirname "$0")/../bin/stt-reset" "$BINDIR/stt-reset"
install -m 755 "$(dirname "$0")/../bin/stt-log" "$BINDIR/stt-log"
install -m 755 "$(dirname "$0")/../bin/stt-last" "$BINDIR/stt-last"
install -m 755 "$(dirname "$0")/../bin/stt-mode-fast-en" "$BINDIR/stt-mode-fast-en"
install -m 755 "$(dirname "$0")/../bin/stt-mode-better-en" "$BINDIR/stt-mode-better-en"
install -m 755 "$(dirname "$0")/../bin/stt-mode-multi-auto" "$BINDIR/stt-mode-multi-auto"
install -m 755 "$(dirname "$0")/../bin/stt-mode-status" "$BINDIR/stt-mode-status"
install -m 755 "$(dirname "$0")/../bin/stt-compare" "$BINDIR/stt-compare"

if ! command -v git >/dev/null 2>&1; then
  echo "Missing dependency: git"
  exit 1
fi

if ! command -v cmake >/dev/null 2>&1; then
  echo "Missing dependency: cmake"
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

echo "Install complete."
echo "whisper-cli: $WHISPER_BIN"
echo "model: $BASE_MODEL"
