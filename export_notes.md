# Nebula Mercy Export Notes

These notes keep the project zero-budget for the current stage. You do not need Google Play Console, Firebase, ads, paid APIs, cloud hosting, or paid assets.

## Android Export Checklist

1. Install Godot 4.x from the official Godot website.
2. In Godot, open this folder as a project.
3. Install Android export templates from `Editor > Manage Export Templates`.
4. Install Android Studio or the Android command line tools so Godot can find the Android SDK.
5. In Godot, open `Editor > Editor Settings > Export > Android` and set the SDK/JDK paths if needed.
6. Open `Project > Export` and add an Android preset.
7. Use the package name `com.student.nebulamercy` or another unique lowercase name.
8. Export a debug APK first.

## APK Testing Checklist

1. Enable developer options and USB debugging on your Android phone.
2. Build a debug APK from Godot.
3. Copy the APK to your phone or install it with `adb install path/to/file.apk`.
4. Confirm portrait layout, touch-drag movement, auto-fire, enemy collisions, restart, mute, pause, and high score saving.
5. Test on at least one lower-end phone if you can.

## GitHub Releases: Free Distribution

1. Create a public GitHub repository.
2. Commit the Godot project files.
3. Build a release APK locally in Godot.
4. Go to `Releases > Draft a new release`.
5. Upload the APK as a release asset.
6. Mention that users may need to allow installing apps from unknown sources.

## itch.io: Free Distribution

1. Create a free itch.io account.
2. Create a new project and choose Android as a platform.
3. Upload the APK.
4. Set pricing to free or pay-what-you-want with zero allowed.
5. Add screenshots from your own gameplay only.

## F-Droid Future Notes

F-Droid can distribute free and open-source Android apps, but it has extra packaging and source-build requirements. Consider it later after the game is stable and the repository is clean.

## Future Play Store AAB Note

Google Play Store publishing is future-only for this project because it is not zero-cost. A Google Play developer account requires a registration fee. If you decide to use Play Store later, export an AAB from Godot and follow Google's signing and policy requirements.
