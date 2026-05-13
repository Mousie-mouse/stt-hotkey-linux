# stt-hotkey-linux
 *Turn your voice into text anywhere on Linux you can paste your clipboard, **no cloud required.**

## What this does

`stt-hotkey-linux` is a local-first speech-to-text hotkey utility for Linux.

Press a keyboard shortcut, speak into your microphone, press again to stop, and get a local Whisper transcript. The project is built around `whisper.cpp`, standard Linux tools, and user-controlled microphone capture.

The goal is simple: make voice input useful without cloud transcription, accounts, always-listening assistants, or opaque audio pipelines.

## Good fit

This tool works best for short-form voice drafting: roughly 1–1000 characters of speech-to-text output.

It is useful for:

- captions
- short scripts
- notes to self
- README edits
- issue comments
- quick emails
- journal fragments
- accessibility workflows
- creator drafts

It is not designed as a perfect meeting transcription system. It is designed for quick, local, user-controlled voice capture.

## Recording length

`stt-hotkey-linux` is tuned for short-form dictation. Recordings around 1–90 seconds are the safest target.

Longer recordings may work, but quiet sections, dead air, breathing, fan noise, or distant speech can increase the chance of repeated phrase hallucinations. Use shorter captures for best results.

## Demo

![stt demo](assets/sttdemo.gif)

---

Local-first speech-to-text toolkit for Linux (Cinnamon/Mint) using `whisper.cpp`. Hotkey-driven recording, clipboard copy, model switching (fast/better/multilingual), and a simple installer.

Local speech-to-text hotkey toolkit for Linux Mint / Cinnamon using `whisper.cpp`.

## What it does

- 🎤 Press a hotkey → speak → Press again to stop and transcribe → text appears in your clipboard
- Saves each transcript to `~/stt-output`
- 🔒 Fully local (no cloud, no API keys)
- Reset stuck state
- Open saved transcript output folder
- Re-copy last to clipboard
- **Advanced** Multiple Whisper models (fast vs accurate - this utility uses minimum viable langauge model sizes)
- **Advanced** Model comparison tool (`stt-compare`)
- **Advanced** Switch between fast English, better English, and multilingual modes

## Requirements

- Linux (tested and built with Mint/Cinnamon)
- X11 clipboard support

## Packages

```bash
sudo apt update
sudo apt install git cmake build-essential ccache ffmpeg sox xclip alsa-utils libnotify-bin
```

---

## 🚀 Quick Install

Clone the repo and run the installer:

```bash
cd ~
git clone https://github.com/Mousie-mouse/stt-hotkey-linux.git
cd ~/stt-hotkey-linux
```
```bash
chmod +x install/install.sh
./install/install.sh
```
### What the installer does

The installer will:

- create local working directories
- install STT commands to ~/.local/bin
- build or verify whisper.cpp
- download required Whisper models
- verify microphone capture tools
- print recommended next steps

**Advanced** commands will prompt you to intstall the needed models on the command's first use, then install

## First Run

Test the tool:

```bash
stt
sleep 5
stt
```

Your transcript will be copied to the clipboard and saved to `~/stt-output`.

To use a different output location, set `STT_OUTPUT_DIR` for the `stt`, `stt-log`, and `stt-last` commands.

---

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
- ALSA doesn't play with all microphone configurations
- Some systems are displaying no notifcations despite functioning normally otherwise

If `stt` is not found immediately after install, open a new terminal or use:

```bash
~/.local/bin/stt
```
---
## Suggested shortcuts

### Hotkeys (Cinnamon)

The only shortcut most users need to remember is:

| Shortcut | Command | Purpose |
|---|---|---|
| `Super+Z` | `/home/$USER/.local/bin/stt` | Start/stop local STT recording |

If you want to run additional models, I recommend adding the hotkey for every model you use and add 'stt-mode-status' so you can toggle the models and confirm your current model.

These are useful but not required.

| Shortcut | Command | Purpose |
|---|---|---|
| `Super+Shift+Z` | `/home/$USER/.local/bin/stt-reset` | Stop/reset a stuck recording |
| `Super+Alt+Z` | `/home/$USER/.local/bin/stt-last` | Show the last transcript |
| `Super+Ctrl+Z` | `/home/$USER/.local/bin/stt-log` | Show the last debug log |

Everything besides `Super+Z` is recovery, configuration, or debugging, but any of the commands can be hotkeys. They are all executable.

## Commands

| Command | Purpose |
|---|---|
| `stt` | Start/stop recording and transcribe locally |
| `stt-reset` | Stop/reset a stuck recording |
| `stt-last` | Show the last transcript |
| `stt-log` | Show the last debug log |
| `stt-mode-fast-en` | Switch to faster English mode |
| `stt-mode-better-en` | Switch to better English mode using `small.en` |
| `stt-mode-multi-auto` | Switch to multilingual auto-detect mode |
| `stt-mode-status` | Show the current STT mode |
| `stt-compare` | Compare model output on a test recording |
| `stt-doctor` | Check install, dependencies, models, microphone, and PATH |
| `stt-update` | Pull latest GitHub changes and reinstall commands |

### Gestures (OS dependent)

Optional. Bind the same commands above to gestures if you prefer touchpad activation, or any other type of shortcuts you want to configure. 

---

## Updating

After installation, update with:

```bash
stt-update
```

Manual update:

```bash
cd ~/stt-hotkey-linux
git pull --ff-only origin main
./install/install.sh
```

## Models (**Advanced** Optional)

By default, the installer downloads only:

- `base.en` → fast, lightweight, English-only

This keeps install size small and fast.

### Install additional models

If you want higher accuracy or multilingual support:

- Better English accuracy
```bash 
./models/download-ggml-model.sh small.en
```
- Multilingual model (auto language detection.
```bash 
./models/download-ggml-model.sh small
```

If you want to add larger models, they are available, but I did not share them because the utility is more helpful to me when it is fast.  

## When to use what

- Use `base.en` → quick notes, commands, low CPU
- Use `small.en` → better transcription quality
- Use `small` → mixed languages / unknown language

---

## Model Comparison Tool (`stt-compare`)

This project includes a utility for comparing Whisper models on the same audio input.

What it does
- runs base.en and small.en
- saves transcropts
- shows differences
- copies best result to clipboard

### Usage

Run on the default test file or most recent transcription:

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

---

## Troubleshooting

Run:

```bash
stt-doctor
```
`stt-doctor` checks:

- installed STT commands
- ~/.local/bin PATH setup
- whisper.cpp
- required models
- microphone capture devices
- working directories
- recent logs
- current STT mode

To inspect the most recent run:

```bash 
stt-log
```
To recover the most recent transcript:
```bash
stt-last
```
To reset a stuck recording:
```bash
stt-reset
```

## Hallucination control

Whisper models can hallucinate repeated phrases when processing long, quiet, or noisy recordings.

The `small.en` mode uses conservative decoding defaults to reduce this risk during hotkey dictation:

```bash
-mc 0 -tp 0 -tpi 0 -nf -ml 80 -sns
```

These settings reduce context carryover, disable temperature fallback, limit segment length, and suppress non-speech tokens.

For best results:

- keep hotkey recordings short
- speak clearly near the microphone
- avoid long dead-air recordings
- use stt-reset if a capture gets stuck
- check stt-log when debugging

## Privacy

This project treats the microphone as a local input device, not a cloud service.

By design:

- transcription runs locally through `whisper.cpp`
- no cloud STT API is required
- no account is required
- recording is user-triggered
- no always-listening assistant is installed
- temporary files and logs are stored locally
- the pipeline is inspectable through shell scripts

A microphone should be an input device, not a surveillance boundary.

---

## Accessibility


This project may be useful as an accessibility aid, especially for reducing typing load.

It may help users who can type, but pay for it through fatigue, pain, repetitive strain, temporary injury, or workflow friction.

It is not medical advice, assistive technology certification, or a guaranteed accommodation tool. Users with access needs should test it carefully against their own workflows and reliability requirements.


## ⚠️  Notes

- Requires working microphone input (ALSA)
- Uses whisper.cpp models locally
- First install will take a few minutes (build + model download)

Security / Privacy

- Runs fully locally (no external API calls)
- Audio never leaves the machine
- Recordings stay temporary in `/tmp/whisper_stt`
- Transcripts are saved locally in `~/stt-output`
- Minimal dependencies

---

### 🤝 Contributing

Issues and PRs welcome. *add socials and walets*

---

### 📜 License

MIT
