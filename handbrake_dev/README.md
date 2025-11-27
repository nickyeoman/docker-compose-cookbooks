# Handbrake
 
DockerHub: https://hub.docker.com/r/jlesage/handbrake
Env docs: https://github.com/jlesage/docker-handbrake

## NOTES

You can specify read and write for example:
"handbrake-storage:/storage:ro"
"handbrake-output:/output:rw"

## Nvidia GPU

HANDBRAKE_IMAGE=zocker160/handbrake-nvenc:latest
Github: https://github.com/zocker-160/handbrake-nvenc-docker
DockerHub NVENC: https://hub.docker.com/r/zocker160/handbrake-nvenc

# Gotchas

```
problem /etc/cont-init.d/55-handbrake.sh: 47: log: not found docker
```
chmod the volumes
and the env file has to be included

## Presets

I think this is the best preset for small file, big quality:
```
 {
                    "AlignAVStart": false,
                    "AudioCopyMask": [
                        "copy:aac"
                    ],
                    "AudioEncoderFallback": "none",
                    "AudioLanguageList": [],
                    "AudioList": [
                        {
                            "AudioBitrate": 128,
                            "AudioCompressionLevel": -1.0,
                            "AudioDitherMethod": "auto",
                            "AudioEncoder": "fdk_aac",
                            "AudioMixdown": "stereo",
                            "AudioNormalizeMixLevel": false,
                            "AudioSamplerate": "auto",
                            "AudioTrackDRCSlider": 0.0,
                            "AudioTrackGainSlider": 0.0,
                            "AudioTrackQuality": 1.0,
                            "AudioTrackQualityEnable": false
                        }
                    ],
                    "AudioSecondaryEncoderMode": true,
                    "AudioTrackSelectionBehavior": "first",
                    "ChapterMarkers": true,
                    "ChildrenArray": [],
                    "Default": true,
                    "FileFormat": "av_mp4",
                    "Folder": false,
                    "FolderOpen": false,
                    "InlineParameterSets": false,
                    "MetadataPassthru": true,
                    "Mp4iPodCompatible": false,
                    "Optimize": false,
                    "PictureAllowUpscaling": false,
                    "PictureAutoCrop": true,
                    "PictureBottomCrop": 0,
                    "PictureChromaSmoothCustom": "",
                    "PictureChromaSmoothPreset": "off",
                    "PictureChromaSmoothTune": "none",
                    "PictureColorspaceCustom": "",
                    "PictureColorspacePreset": "off",
                    "PictureCombDetectCustom": "",
                    "PictureCombDetectPreset": "off",
                    "PictureCropMode": 2,
                    "PictureDARWidth": 1920,
                    "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
                    "PictureDeblockPreset": "off",
                    "PictureDeblockTune": "medium",
                    "PictureDeinterlaceCustom": "",
                    "PictureDeinterlaceFilter": "off",
                    "PictureDeinterlacePreset": "",
                    "PictureDenoiseCustom": "",
                    "PictureDenoiseFilter": "off",
                    "PictureDenoisePreset": "",
                    "PictureDenoiseTune": "none",
                    "PictureDetelecine": "off",
                    "PictureDetelecineCustom": "",
                    "PictureForceHeight": 0,
                    "PictureForceWidth": 0,
                    "PictureHeight": 0,
                    "PictureItuPAR": false,
                    "PictureKeepRatio": true,
                    "PictureLeftCrop": 0,
                    "PictureModulus": 2,
                    "PicturePAR": "auto",
                    "PicturePARHeight": 1,
                    "PicturePARWidth": 1,
                    "PicturePadBottom": 0,
                    "PicturePadColor": "black",
                    "PicturePadLeft": 0,
                    "PicturePadMode": "none",
                    "PicturePadRight": 0,
                    "PicturePadTop": 0,
                    "PictureRightCrop": 0,
                    "PictureRotate": "angle=0:hflip=0",
                    "PictureSharpenCustom": "",
                    "PictureSharpenFilter": "off",
                    "PictureSharpenPreset": "",
                    "PictureSharpenTune": "",
                    "PictureTopCrop": 0,
                    "PictureUseMaximumSize": true,
                    "PictureWidth": 0,
                    "PresetDescription": "Nvidia NVENC hardware accelerated H.265 video (up to 2160p) and AAC stereo audio, in an MP4 container.",
                    "PresetDisabled": false,
                    "PresetName": "sameRes-cpu-265",
                    "SubtitleAddCC": false,
                    "SubtitleAddForeignAudioSearch": false,
                    "SubtitleAddForeignAudioSubtitle": false,
                    "SubtitleBurnBDSub": false,
                    "SubtitleBurnBehavior": "none",
                    "SubtitleBurnDVDSub": false,
                    "SubtitleLanguageList": [],
                    "SubtitleTrackSelectionBehavior": "none",
                    "Type": 1,
                    "UsesPictureFilters": true,
                    "VideoAvgBitrate": 7000,
                    "VideoColorMatrixCodeOverride": 0,
                    "VideoEncoder": "x265",
                    "VideoFramerate": "auto",
                    "VideoFramerateMode": "vfr",
                    "VideoGrayScale": false,
                    "VideoHWDecode": 0,
                    "VideoLevel": "auto",
                    "VideoMultiPass": true,
                    "VideoOptionExtra": "",
                    "VideoPreset": "slow",
                    "VideoProfile": "auto",
                    "VideoQSVDecode": false,
                    "VideoQualitySlider": 27.0,
                    "VideoQualityType": 2,
                    "VideoScaler": "swscale",
                    "VideoTune": "",
                    "VideoTurboMultiPass": false,
                    "x264Option": "",
                    "x264UseAdvancedOptions": false
                },
```