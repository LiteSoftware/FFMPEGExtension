#!/bin/bash

# More details: https://udfsoft.com 

ENABLED_DECODERS=(vorbis opus flac alac aac ec3 eac3 dca mlp truehd)
HOST_PLATFORM="linux-x86_64"
NDK_PATH="$(pwd)/android-ndk-r22b"
SDK_PATH=$1
# SDK_PATH=/home/user/Android/Sdk

if [ -z $1  ]; then
  echo 'Pass SDK_PATH!'
  echo 'Example: ./build.sh /home/udfsoft/Android/Sdk'
  exit
fi

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

echo "sdk.dir=${SDK_PATH}" > local.properties

./gradlew extension-ffmpeg:assembleRelease

echo "The library is complete!"
echo "It should be located in this path: ${EXOPLAYER_PATH}/extensions/ffmpeg/buildout/outputs/aar/"
