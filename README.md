# Swifty Companion

A Flutter app that uses the 42 API to look up students and show their profiles.

This guide explains how to run the app from a fresh clone on a machine without
sudo access, such as a 42 school computer.

## Requirements

- Flutter 3.47.8 or newer (`pubspec.yaml` requires Dart `^3.13.7`)
- A 42 API application, for its UID and secret

## Setup Flutter

`goinfre` is local to each machine and can be wiped, so on any new school
machine you have to clone everything again. Everything goes into
`/goinfre/$USER`, so nothing fills your home quota.

Run these in one terminal, in this order:

```sh
# 1. Work in goinfre
cd /goinfre/$USER

# 2. Install Flutter (no sudo needed)
git clone -b 3.47.8 --depth 1 https://github.com/flutter/flutter.git /goinfre/$USER/flutter

# 3. Set up this terminal: Flutter on PATH, caches in goinfre, browser for web
export PATH="/goinfre/$USER/flutter/bin:$PATH"
export PUB_CACHE="/goinfre/$USER/.pub-cache"
export CHROME_EXECUTABLE="$(command -v google-chrome || command -v chromium-browser || command -v chromium)"

# 4. Clone the project
git clone https://github.com/Jamie135/swifty-companion.git /goinfre/$USER/swifty-companion
cd /goinfre/$USER/swifty-companion

# 5. Create .env, then put your UID and secret in it (see "Create the .env file")
cp .env.example .env
nano .env

# 6. Check the tools, fetch packages and run
flutter doctor
flutter pub get
flutter run -d chrome --web-port 8080   # or: flutter run -d linux
```

The `export` lines only last for the current terminal. If you open a new
terminal, run step 3 again before using `flutter`.

If `flutter devices` doesn't list `chrome`, check that `echo $CHROME_EXECUTABLE`
prints a path. If it's empty, no Chrome or Chromium is installed on that
machine, so use `flutter run -d linux` instead.

## Create and launch the app

### Create

```sh
flutter create <app_name>
```
This command generates a starter folders/files for a Flutter project with a working starter app such as:
- `pubspec.yaml`
- `lib/main.dart` **(the app's main code)**
- `android/` ; `ios/` ; `linux` ; `web` ; etc... **(folders to run our app in different platforms)**
### Linux

```sh
flutter run -d linux
```

### Chrome

Flutter only looks for `google-chrome`. If the machine has Chromium instead,
point Flutter at it first:

```sh
export CHROME_EXECUTABLE="$(command -v google-chrome || command -v chromium-browser || command -v chromium)"
flutter run -d chrome --web-port 8080
```

### Mobile

Mobile needs the Android toolchain and an emulator set up in Android Studio.
List your emulators, start one, then run the app on it:

```sh
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

To use a phone connected by USB, turn on USB debugging on the phone, then find
its ID and run the app on it:

```sh
flutter devices
flutter run -d <device_id>
```

## Setup Android SDK

### 1. Download and unpack

```sh
mkdir -p /goinfre/$USER/android && cd /goinfre/$USER/android
# Copy the current Linux .tar.gz link from https://developer.android.com/studio
wget <linux-tar.gz-url>
tar -xzf android-studio-*-linux.tar.gz
./android-studio/bin/studio.sh
```

### 2. Keep the big data out of your home folder

On first run, set the location in the **SDK Components Setup** to
`/goinfre/$USER/android/sdk`. 

The SDK and emulator images take several GB,
so they won't fit in home.

Also move Gradle's cache and the emulator's AVD files:

```sh
echo 'export GRADLE_USER_HOME=/goinfre/$USER/android/gradle' >> ~/.bashrc
echo 'export ANDROID_AVD_HOME=/goinfre/$USER/android/avd' >> ~/.bashrc
```

## Troubleshooting

| Problem | Fix |
|---|---|
| `flutter: command not found` | Run `export PATH="/goinfre/$USER/flutter/bin:$PATH"`, or check that `/goinfre/$USER/flutter` still exists (goinfre may have been wiped). |
| `No supported devices found with name or id matching 'chrome'` | Set `CHROME_EXECUTABLE` as shown in the Chrome section. |
| Dart SDK version error during `flutter pub get` | Your Flutter is too old. Install 3.47.8 or newer. |
| Build error about a missing `.env` asset | Create `.env` as described in step 3. |
| API calls return 401 | Check the values in `.env`, and check that the secret hasn't expired. |
