# Iosveka Custom Build Script

This repo provides a script to build **Iosevka Custom Fonts** automatically with GitHub Actions.

## How To Use

1. Fork this [repo](https://github.com/Shourene/Iosveka-custom/fork)
2. Customize [`private-build-plans.toml`](config/private-build-plans.toml) using [Iosveka Customizer](https://typeof.net/Iosevka/customizer)
3. Run the build [workflow](../../actions/workflows/build.yml)
   - Select the build_plan according to the plan name in `private-build-plans.toml.`
   - Select the build_targets separated by commas `(e.g., contents,ttf,ttf-unhinted).`
4. Grab your custom fonts from [releases](../../releases)
