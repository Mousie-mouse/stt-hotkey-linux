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

- `Linux with X11 clipboard support`
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

```bash cd ~/whisper.cpp ```
```bash ./models/download-ggml-model.sh base.en ```
```bash ./models/download-ggml-model.sh small.en ```
```bash ./models/download-ggml-model.sh small ```


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

## Model Comparison Tool (`stt-compare`)

This project includes a utility for comparing Whisper models on the same audio input.

It runs multiple models, saves transcripts, shows differences, and copies the best result to your clipboard.

---

### Usage

Run on the default test file:

```bash
stt-compare
```

Run on a specific audio file: 

```bash stt-compare ~/stt-audio-tests/audio/base-test.wav ```

What it does

- Runs ` base.en ` (fast & light)
- Runs ` small.en` (more accurate)
- Saves Transcripts to: ```text ~/stt-audio-tests/transcripts/ ```
- Displays both outputs w side-to-side comparison
- Copies `small.en` result to the clipboard

### Example Workflow

- Record audio
```bash 
stt
sleep 5
stt
```
- Save the recording
```bash
mkdir -p ~/stt-audio-tests/audio
cp /tmp/whisper_stt/record.wav ~/stt-audio-tests/audio/test.wav
```
- Compare models
```bash stt-compare ~/stt-audio-tests/audio/test.wav
```

### Why Compare?
Different whisper models trade speed for accuracy. This tool lets you directly compare outputs on identical audio, and creates options for future development of tools that will improve this type of workflow

## Notes

This repo does not package `whisper.cpp` itself. It expects a local build in `~/whisper.cpp` and uses the current `whisper-cli` binary from that build.

## Security / Privacy Notes

- Runs fully locally (no external API calls)
- Audio never leaves the machine
- No persistent storage of recordings
- Minimal dependencies
