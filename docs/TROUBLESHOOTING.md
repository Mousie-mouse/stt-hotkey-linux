# Troubleshooting

This project was tested across multiple Linux Mint systems with different audio hardware. Most failures were caused by audio-device selection, ALSA format constraints, missing models, or shell/desktop-environment differences rather than Whisper itself.

## 1. stt runs, but nothing happens

First verify the installed scripts exist and are executable:

```bash
ls -l ~/.local/bin/stt
ls -l ~/.local/bin/stt-*
```
### If needed:
```bash 
chmod +x ~/.local/bin/stt ~/.local/bin/stt-*
```
If stt is not found as a command, either add ~/.local/bin to your shell PATH or use the full path in your desktop shortcut:
```bash
/home/your-user/.local/bin/stt
```
## 2. notify-send throws a D-Bus / Notifications error

Example:
```text
GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.Notifications was not provided by any .service files
```
This means your desktop session does not have a notification daemon available. The STT scripts should still work if notifications are treated as optional.

The scripts in this repo are designed to continue running even when desktop notifications are unavailable. This affects visual feedback only, not transcription. The freedesktop notification service is optional to the tool itself.

## 3. stt records silence or blank audio

Test the recording path directly:
```bash
~/.local/bin/stt
sleep 5
~/.local/bin/stt
aplay /tmp/whisper_stt/record.wav
```
If playback is blank or silent, the problem is the audio input device, not Whisper.

List capture devices:
```bash
arecord -l
```
List ALSA PCM names:
```bash
arecord -L | sed -n '1,120p'
```
On some laptops, the default audio device is wrong, or ALSA defaults to HDMI/playback instead of the internal mic.

Use alsamixer to select the correct card and capture controls:
```bash
alsamixer
```
Then:

* F6 → choose the correct sound card
* F4 → switch to Capture
* raise Mic, Internal Mic, or Capture levels as needed

Using F6 to choose the sound card and F4 for capture is standard ALSA workflow.

## 4. arecord fails with channel or sample-rate errors

Example:
```text
arecord: set_params:1358: Channels count non available
```
This means the raw hardware device does not support the requested mono / sample-rate combination directly.

Check the device’s supported parameters:
```bash
arecord --dump-hw-params -D hw:1,0 -d 1 /tmp/test.wav
```
Some laptop mics only support stereo and 44.1 kHz or higher on the raw hw: device. In that case, use a converting ALSA device like plughw: instead of hw:.

Example working pattern:
```bash
arecord -D plughw:CARD=PCH,DEV=0 -f S16_LE -c 1 -r 16000 -d 5 /tmp/mic-test.wav
aplay /tmp/mic-test.wav
```

## 5. whisper-cli exists, but the script says the model is missing

Check the expected model path:
```bash
ls -l ~/whisper.cpp/models/ggml-base.en.bin
```
If the file is missing, download it:
```bash
cd ~/whisper.cpp
bash ./models/download-ggml-model.sh base.en
```
For a better English model:

```bash ./models/download-ggml-model.sh small.en
```
For multilingual transcription:

```bash ./models/download-ggml-model.sh small
```
whisper.cpp uses models like ggml-base.en.bin, and the official repo provides the download script for those files.

## 6. Recording works, but no transcript is produced

First test Whisper directly against the captured WAV:
```bash
~/whisper.cpp/build/bin/whisper-cli \
  -m ~/whisper.cpp/models/ggml-base.en.bin \
  -f /tmp/whisper_stt/record.wav \
  -l en
```
If this prints nothing, the issue is usually one of:

* the mic captured silence or very low volume
* the wrong input device is being used
* the clip is too short
* the model is too weak for the audio quality

Try:

* speaking longer
* moving closer to the mic
* using a stronger model like small.en

## 7. Multilingual auto-detect guesses the wrong language

In multilingual mode, Whisper may misclassify short or noisy English clips as another language. This is a model behavior issue, not necessarily a script bug.

If auto mode is unreliable for your mic/environment, use:

* multilingual model with forced English for English speech
* multilingual auto-detect only for genuine mixed-language use

This repo’s stt-mode-multi-auto is best treated as a convenience mode, not a guarantee of perfect language ID on low-quality input.

## 8. Linux Mint / Cinnamon shortcut works on one machine but not another

Check the shortcut command first. If stt is not on PATH, use the full installed path:
```bash
/home/your-user/.local/bin/stt
```
Also verify the shell environment. On zsh systems, add this to ~/.zshrc instead of ~/.bashrc:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
Then reload:
```bash
source ~/.zshrc
```
** If you accidentally source ~/.bashrc from zsh, you may see errors from bash-specific commands like shopt. **

## 9. Installed scripts are updated in the repo, but not on the target machine

Pull the latest repo changes, then rerun the installer:
```bash
cd ~/stt-hotkey-linux
git pull
./install/install.sh
```
Do not run git pull ./install.sh; that makes Git interpret ./install.sh as an argument to git pull.

## 10. Useful debug commands

These are the fastest checks when something is off:

### verify script + helpers are installed
```bash ls -l ~/.local/bin/stt ~/.local/bin/stt-*
```
### verify capture devices
```bash 
arecord -l
arecord -L | sed -n '1,120p'
```
### verify model exists
```bash ls -l ~/whisper.cpp/models/ggml-base.en.bin
```
### inspect current runtime state
```bash ls -l /tmp/whisper_stt
```
# inspect current transcript
```bash cat /tmp/whisper_stt/last_transcript.txt
```
# inspect raw recording for playback test
```bash aplay /tmp/whisper_stt/record.wav
```
# trace script execution (debug trace)
```bash -x ~/.local/bin/stt 2>&1 | tee /tmp/stt-debug.txt ```

## 11. Known hardware-specific note

Some machines need the arecord line in stt adjusted to a device-specific ALSA input.

Example:
```bash
arecord -D plughw:CARD=PCH,DEV=0 -q -f S16_LE -c 1 -r 16000 "$WAV_FILE" >"$LOG_FILE" 2>&1 &
```
If default capture works on your system, leave it alone. If your machine records silence or the wrong source, use arecord -l, arecord -L, and alsamixer to identify the correct capture device first.
