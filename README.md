# stt-hotkey-linux

Local-first speech-to-text toolkit for Linux (Cinnamon/Mint) using `whisper.cpp`. Hotkey-driven recording, clipboard copy, model switching (fast/better/multilingual), and a simple installer.

Local speech-to-text hotkey toolkit for Linux Mint / Cinnamon using `whisper.cpp`.

## What it does

- Press once to start recording
- Press again to stop and transcribe
- Copy transcript to clipboard
- Switch between fast English, better English, and multilingual modes
- Reset stuck state
- View logs
- Re-copy the last transcript

## Requirements

- Linux with X11 clipboard support
- `whisper.cpp`
- `arecord`
- `xclip`
- `notify-send`

## Packages

```bash
sudo apt update
sudo apt install git cmake build-essential ffmpeg sox xclip alsa-utils libnotify-bin
```

## Build whisper.cpp

```bash
cd ~
git clone https://github.com/ggml-org/whisper.cpp
cd whisper.cpp
cmake -B build
cmake --build build -j --config Release
```

## Download models

```bash
cd ~/whisper.cpp
bash ./models/download-ggml-model.sh base.en
bash ./models/download-ggml-model.sh small.en
bash ./models/download-ggml-model.sh small
```

## Install this toolkit

```bash
cd ~/stt-hotkey-linux
./install/install.sh
```

## Suggested shortcuts

- `Super+Z` → `stt`
- `Super+Shift+Z` → `stt-reset`
- `Ctrl+Shift+L` → `stt-log`
- `Super+Shift+V` → `stt-last`
- `Super+Alt+1` → `stt-mode-fast-en`
- `Super+Alt+2` → `stt-mode-better-en`
- `Super+Alt+3` → `stt-mode-multi-auto`
- `Super+Alt+0` → `stt-mode-status`

## Notes

This repo does not package `whisper.cpp` itself. It expects a local build in `~/whisper.cpp` and uses the current `whisper-cli` binary from that build.

## Security / Privacy Notes

- Runs fully locally (no external API calls)
- Audio never leaves the machine
- No persistent storage of recordings
- Minimal dependencies
