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

- Linux (tested and built with Mint/Cinnamon)
- X11 clipboard support

## Packages

```bash
sudo apt update
sudo apt install git cmake build-essential ffmpeg sox xclip alsa-utils libnotify-bin
```

## Install

Clone the repo and run the installer:

```bash
cd ~
git clone https://github.com/Mousie-mouse/stt-hotkey-linux.git
cd ~/stt-hotkey-linux
./install/install.sh
```
### What the installer does

The installer automatically:

- Installs all stt-* scripts to ~/.local/bin
- Clones and builds whisper.cpp (if missing)
- Downloads the base.en model
- Creates runtime directories:
>-  ~/stt-audio-tests/audio
>- ~/stt-audio-tests/transcripts
- Verifies installation

No manual whisper setup required.

## First Run

Test the tool:

```bash
stt
sleep 5
stt
```

Your transcript will be copied to the clipboard.

## Troubleshooting Audio (Important)

If transcription returns empty:

1. Check devices
```bash
arecord -l
```
2. List usable inputs
```bash
arecord -L | sed -n '1,120p'
```
3. Test microphone manually
```bash
arecord -D plughw:CARD=PCH,DEV=0 -f S16_LE -c 2 -r 16000 -d 5 /tmp/test.wav
aplay /tmp/test.wav
```
4. Adjust input levels
```bash
alsamixer
```
Common issue:

- Hardware often requires stereo (2 channels)
- plughw: is required for resampling

## Suggested shortcuts

- `Super+Z` → `stt`
- `Super+Shift+Z` → `stt-reset`
- `Ctrl+Shift+L` → `stt-log`
- `Super+Shift+V` → `stt-last`
- **Advanced** `Super+Alt+1` → `stt-mode-fast-en`
- **Advanced** `Super+Alt+2` → `stt-mode-better-en`
- **Advanced** `Super+Alt+3` → `stt-mode-multi-auto`
- **Advanced** `Super+Alt+0` → `stt-mode-status`
- **Advanced** `Super+Alt+c`→ `stt-compare`

## Models (Optional)

By default, the installer downloads only:

- `base.en` → fast, lightweight, English-only

This keeps install size small and fast.

---

### Install additional models

If you want higher accuracy or multilingual support:

```bash
cd ~/whisper.cpp
```

- Better English accuracy
```bash 
./models/download-ggml-model.sh small.en
```
- Multilingual model (auto language detection)
```bash 
./models/download-ggml-model.sh small
```

If you want to add larger models, you can install the others from whisper.cpp. I wanted minimum viable tool. If you have extra VRAM - go for it. (you will have fun with the stt-compare tool) 

## When to use what
- Use `base.en` → quick notes, commands, low CPU
- Use `small.en` → better transcription quality
- Use `small` → mixed languages / unknown language

## Switching modes
- `base.en` 
```bash
stt-mode-fast-en
```
- `small.en`
 ```bash
 stt-model-better-en
```
- `small` (*auto-detects multiple languages* (This is where I would recommend a larger whisper model))

## Model Comparison Tool (`stt-compare`)

This project includes a utility for comparing Whisper models on the same audio input.

It runs multiple models, saves transcripts, shows differences, and copies the best result to your clipboard. 

### Usage

Run on the default test file:

```bash
stt-compare
```

Run on a specific audio file: 

```bash 
stt-compare ~/stt-audio-tests/audio/base-test.wav
 ```

What it does

- Runs ` base.en ` (fast & light)
- Runs ` small.en` (more accurate if installed)
- Saves Transcripts to: ` ~/stt-audio-tests/transcripts/ `
- Displays both outputs w side-to-side comparison
- Copies result to the clipboard

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

```bash
 stt-compare ~/stt-audio-tests/audio/test.wav
```

## Notes

This repo does not package `whisper.cpp` itself. It expects a local build in `~/whisper.cpp` and uses the current `whisper-cli` binary from that build.

## Security / Privacy Notes

- Runs fully locally (no external API calls)
- Audio never leaves the machine
- No persistent storage of recordings
- Minimal dependencies
