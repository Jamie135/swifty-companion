# Swifty Companion

A Flutter app that uses the 42 API to look up students and show their profiles.

This guide explains how to run the app from a fresh clone on a machine without
sudo access, such as a 42 school computer.

## Requirements

- Flutter 3.47.8 or newer (`pubspec.yaml` requires Dart `^3.13.7`)
- A 42 API application, for its UID and secret

## Setup

### 1. Install Flutter

The Flutter SDK installs into your home folder, so it doesn't need sudo.

```sh
git clone -b 3.47.8 --depth 1 https://github.com/flutter/flutter.git ~/flutter
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

If your shell is bash, use `~/.bashrc` instead of `~/.zshrc`.

The SDK takes up a few GB. If your home quota is too small, clone it into your
school's larger storage folder (often `goinfre` or `sgoinfre`) and change the
path in both commands.

### 2. Clone the project

```sh
git clone https://github.com/Jamie135/swifty-companion.git
cd swifty-companion
```

If the repository is private, HTTPS asks for a GitHub token rather than your
password.

### 3. Create the `.env` file

`.env` is gitignored, so it isn't included in the clone. The build fails without
it, because it's declared as an asset in `pubspec.yaml`.

```sh
cp .env.example .env
```

Then replace the placeholders with the UID and secret from your 42 API
application page:

```sh
CLIENT_ID=your_uid_here
CLIENT_SECRET=your_secret_here
```

Check on that page that the secret hasn't expired. Never commit this file.

### 4. Check the tools and run

```sh
flutter doctor
flutter pub get
flutter run -d linux
```

In the `flutter doctor` output, only the **Linux toolchain** line matters here.
It needs `clang`, `cmake`, `ninja`, `pkg-config` and the GTK headers.

## If the Linux toolchain is missing

These tools can't be installed without sudo. Instead, build an APK on a machine
that has the Android toolchain, then install it on an Android phone.

The release build needs the `INTERNET` permission, or every API call fails.
Debug builds get it automatically, but release builds don't. If it's missing,
add this line inside `<manifest>` in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Then build the APK:

```sh
flutter build apk --release
```

The file is created at `build/app/outputs/flutter-apk/app-release.apk`.

The APK contains your `.env` file, including the API secret, so don't share it.

## Troubleshooting

| Problem | Fix |
|---|---|
| `flutter: command not found` | Open a new terminal, or check the `PATH` line in your shell config. |
| Dart SDK version error during `flutter pub get` | Your Flutter is too old. Install 3.47.8 or newer. |
| Build error about a missing `.env` asset | Create `.env` as described in step 3. |
| API calls return 401 | Check the values in `.env`, and check that the secret hasn't expired. |
