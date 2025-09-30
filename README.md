# Iosevka Custom Build Script

This repo provides a script to build **Iosevka Custom Fonts** automatically with GitHub Actions.

## How To Use

1. Fork this [repo](https://github.com/Shourene/Iosevka-custom/fork).
2. Customize [`private-build-plans.toml`](../private-build-plans.toml) using the [Iosevka Customizer](https://typeof.net/Iosevka/customizer).
3. Run the build [workflow](../../actions/workflows/build.yml).
   - Select the **build_target** according to what you want to build:
     - `contents` → TTF + Web Font
     - `ttf` → TTF
     - `ttf-unhinted` → TTF Unhinted
4. Grab your custom fonts from:
   - [Releases](../../releases) (zipped, with build log)
   - or from the `output` branch (latest build files)

## Repo Structure
- `setup.sh` → Setup system dependencies
- `build.sh` → Build script for Iosevka
- `.github/workflows/build.yml` → GitHub Actions workflow
- `private-build-plans.toml` → Font customization config