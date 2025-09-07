This project includes a vector face icon at `assets/icons/face_icon.svg` and a helper script to generate platform launcher icons.

Quick steps

1. Ensure you have one of:
   - librsvg (rsvg-convert)
   - ImageMagick (convert)

2. Run the generator script from project root:

   ./tools/generate_icons.sh

3. Run:

   flutter pub get

4. Rebuild your app for each platform:

   flutter build apk
   flutter build ios
   flutter build web

Notes
- The script overwrites existing Android mipmap `ic_launcher.png` files and iOS AppIcon files. Make backups if needed.
- Alternatively, install and configure `flutter_launcher_icons` and point `image_path` in `pubspec.yaml` to a PNG to have it auto-generate icons.
