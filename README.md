# Nebula Mercy: Space Defender

Nebula Mercy is an original, offline-first, portrait mobile arcade shooter made with Godot 4.x and GDScript. The player controls a ship near the bottom of the screen, auto-fires upward, destroys enemy drones, collects powerups, and tries to protect the planets below.

## Zero-Budget Statement

This project is designed for a student budget of zero. It does not require Google Play Console, Firebase, ads, in-app purchases, cloud servers, paid APIs, subscriptions, paid plugins, or paid assets. All current visuals are original code-drawn shapes, polygons, stars, and particles.

## Features

- Portrait 1080x1920 reference layout.
- Main menu with Play, How to Play, Credits, and desktop-only Exit behavior.
- Touch-drag movement for Android.
- WASD and arrow-key movement for desktop testing.
- Automatic shooting every 0.25 seconds.
- Basic, fast, and tank enemy drones.
- Slowly increasing spawn difficulty.
- Health, double-shot, and shield powerups.
- Score, high score, health display, pause, mute, and game over UI.
- Local high score saving with Godot `user://` storage.
- Generated placeholder sound tones through `AudioManager`.

## Controls

- Android: touch-drag the ship.
- Desktop: WASD or arrow keys.
- Shooting: automatic.
- Pause and mute: on-screen buttons.

## How to Run in Godot

1. Install Godot 4.x.
2. Open Godot Project Manager.
3. Choose `Import`.
4. Select this folder: `C:\Users\MOHD SOHAIB ALI\OneDrive\Documents\New project`.
5. Open the project and press Play.

The main scene is `res://scenes/MainMenu.tscn`.

## How to Export a Debug APK

1. In Godot, install Android export templates from `Editor > Manage Export Templates`.
2. Install Android SDK tools through Android Studio or command line tools.
3. Configure Android paths in `Editor > Editor Settings > Export > Android`.
4. Go to `Project > Export`.
5. Add an Android preset.
6. Export a debug APK and test it on your own phone.

## Free APK Distribution Later

GitHub Releases:

1. Build a release APK locally.
2. Create a GitHub release.
3. Upload the APK file.
4. Tell users it is a free student project and may require allowing unknown-source APK installs.

itch.io:

1. Create a free itch.io project.
2. Select Android as the platform.
3. Upload the APK.
4. Set the price to free.

## Future Play Store Note

Play Store publishing is not part of this zero-budget stage. Google Play requires a paid developer account registration fee. If you choose Play Store later, export an AAB from Godot and follow Google's signing and policy requirements.

## Resume Bullet Points

- Built an original offline Android arcade shooter prototype in Godot 4.x using GDScript.
- Implemented touch and keyboard movement, auto-fire combat, enemy waves, powerups, local high score persistence, and mobile-friendly UI.
- Created zero-budget placeholder art and audio using code-generated shapes, particles, and tones.
- Documented free APK testing and distribution paths through GitHub Releases and itch.io.

## Disclaimer

Nebula Mercy: Space Defender is an original educational arcade shooter inspired only by the broad vertical shooter genre. It does not use copyrighted art, music, icons, screenshots, UI, enemy designs, paid assets, paid services, ads, or in-app purchases.
