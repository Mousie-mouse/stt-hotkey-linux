#!/usr/bin/env bash
set -euo pipefail

PREFIX="${HOME}/.local"
BINDIR="${PREFIX}/bin"
APPDIR="${HOME}/.config/stt-hotkey-linux"

echo "Installing STT Hotkey scripts..."

mkdir -p "$BINDIR"
mkdir -p "$APPDIR"

install -m 755 "$(dirname "$0")/../bin/stt" "$BINDIR/stt"
install -m 755 "$(dirname "$0")/../bin/stt-reset" "$BINDIR/stt-reset"
install -m 755 "$(dirname "$0")/../bin/stt-log" "$BINDIR/stt-log"
install -m 755 "$(dirname "$0")/../bin/stt-last" "$BINDIR/stt-last"
install -m 755 "$(dirname "$0")/../bin/stt-mode-fast-en" "$BINDIR/stt-mode-fast-en"
install -m 755 "$(dirname "$0")/../bin/stt-mode-better-en" "$BINDIR/stt-mode-better-en"
install -m 755 "$(dirname "$0")/../bin/stt-mode-multi-auto" "$BINDIR/stt-mode-multi-auto"
install -m 755 "$(dirname "$0")/../bin/stt-mode-status" "$BINDIR/stt-mode-status"
install -m 755 "$(dirname "$0")/../bin/stt-compare" "$BINDIR/stt-compare"


cat <<EOF

Installed to:
  $BINDIR

Next:
  1. Make sure these dependencies exist:
     git cmake build-essential ffmpeg sox xclip alsa-utils libnotify-bin
  2. Build whisper.cpp in ~/whisper.cpp
  3. Download the models you want
  4. Point Cinnamon shortcuts to:
       stt
       stt-reset
       stt-log
       stt-last
       stt-mode-fast-en
       stt-mode-better-en
       stt-mode-multi-auto
       stt-mode-status

EOF
