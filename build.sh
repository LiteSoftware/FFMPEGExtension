#!/bin/bash

ENABLED_DECODERS=(vorbis opus flac alac aac ec3 eac3 dca mlp truehd)
HOST_PLATFORM="linux-x86_64"
NDK_PATH="$(pwd)/android-ndk-r22b"

wget https://dl.google.com/android/repository/android-ndk-r22b-linux-x86_64.zip -O ndk.zip
unzip ./ndk.zip

git clone https://github.com/google/ExoPlayer.git
cd ExoPlayer

EXOPLAYER_PATH="$(pwd)"
FFMPEG_MODULE_PATH="$(pwd)/extensions/ffmpeg/src/main"

if [ -d ./ffmpeg ]; then
  echo "ffmpeg directory exists!"
  echo "Remove it!"
  rm -R -f ./ffmpeg
fi

git clone git://source.ffmpeg.org/ffmpeg
cd ffmpeg
git checkout release/4.2
FFMPEG_PATH="$(pwd)"

cd "${FFMPEG_MODULE_PATH}/jni"

echo "cd to ${FFMPEG_MODULE_PATH}/jni"

rm -R -f ./ffmpeg

ls

ln -s "$FFMPEG_PATH" ffmpeg

cd "${FFMPEG_MODULE_PATH}/jni"

./build_ffmpeg.sh "${FFMPEG_MODULE_PATH}" "${NDK_PATH}" "${HOST_PLATFORM}" "${ENABLED_DECODERS[@]}"

cd $EXOPLAYER_PATH
./gradlew extension-ffmpeg:assembleRelease
