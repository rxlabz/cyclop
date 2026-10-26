# 1.0.0
- Fix `OverlayEntry` memory leaks on widget disposal in `ColorButton` and `EyeDrop`
- Fix premature `onColorChanged` callback on `ColorButton` tap-down
- Refactor `EyeDrop` to a `StatefulWidget` with instance-scoped state and idle pointer guards
- Fix stale color reference in `ColorPicker` when changing opacity or hex value
- Full Flutter Web / WASM (`dart2wasm`) compatibility (removed deprecated `dart:js` and unified web/native implementations)
- Remove external dependencies (`image`, `quiver`, `basics`) — zero third-party dependencies
- Dismiss `ColorButton` picker overlay on outside tap or button re-tap
- Sync external color updates in `HSLSliders` and remove artificial hue/saturation clamping
- Fix `UnsupportedError` when adding swatches to default `const {}` set in `SwatchLibrary`
- Fix eyedropper sampling grid centering and custom grid size handling in `getPixelColors`
- Enable copy/paste selection and focus-loss submission in `HexColorField`
- Migrate to modern Flutter APIs (`WidgetStateProperty`, `Color.withValues`, `SliderTheme`, `super.key`)

# 0.7.0
- fix EyedropperButton ( repaintBoundaryToImage )
- Dart 3.0

# 0.6.2
- upgrade dependencies and minor refactoring

# 0.6.1

- Update the deprecated theme properties
- Migrate to Flutter 3.7 slider API : Thx [@alonohana627](https://github.com/alonohana627)

# 0.6.0

- add a `onColorChanged` callback to send the hovered color during eyedropping. Thx [@talisk](https://github.com/talisk)

# 0.5.1

- Fix : EyedropperButton exception on first click
- Fix : Mobile landscape layout

# 0.5.0

- Draggable ColorPicker
- better display of alpha colors in ColorButton & ColorPicker  
- Fix : Hex value field with alpha = 0
# 0.4.1

- ColorButton & ColorPicker : onSwatchesUpdate is now optional  

# 0.4.0

- Enable the eyeDropper in browser with CanvasKit renderer

# 0.3.0+2

- NNBD

# 0.2.3

- Mobile: resize when keyboard toggles 
- fix HexField

# 0.2.2

- Add a EyeDropperButton to use EyeDropper outside the colorpicker
- ColorButton : add a decoration optional constructor arguments
- MIT licence

# 0.2.1

- fix compatibility with Flutter stable channel

# 0.2.0

- rename to Cyclop
- Fix : HSL weird saturation / lightness behaviour
- Updated example
- pub.dev

# 0.1.0

- Initial version

