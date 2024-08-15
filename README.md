# 🎵 Flutter Audio Player App for iOS 🎵

## 🎯 Objective

This Flutter app demonstrates an audio player for iOS, showcasing Clean Architecture, MVVM, and state management using BLoC. The app plays m3u8 HLS audio streams and includes several key features.

## ✨ Key Features

1. 🔊 **M3U8 HLS Audio Playback**
   - Playback of HTTP Live Streaming audio formats - Please note this is dumy project I have just hardcoded a static url for now.

2. 🎛️ **Player Controls**
   - ▶️ Play/Pause functionality
   - ⏪ Rewind 10 seconds
   - ⏩ Fast forward 10 seconds

3. 🏃‍♂️ **Background Media Playback**
   - Continuous audio playback when app is minimized or screen is off

4. 💾 **State Preservation** (Optional)
   - Retains track state when app is closed and reopened

## 🛠️ Technical Requirements

1. 🏗️ **Architectural Pattern**
   - Implemented using Clean Architecture
   - BLoC for state management

2. 🧵 **Background Playback**
   - Utilizes Flutter Isolates for storing/re-storing last played position

## Video Demo

https://github.com/user-attachments/assets/79e0e02b-6e05-4984-bc25-514cdf9cda24

