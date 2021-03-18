import 'dart:js' as js;

/// Color picker config
/// allow to disable some part of the picker :
/// - [enableOpacity] : hide/show the opacity slider
/// - [enableLibrary] : hide/show the custom library tab
/// - [enableEyePicker] : hide/show the eyedropper button ( should be disabled in html renderer )
///
/// With Flutter web the eyedropper is disabled with the html renderer
class ColorPickerConfig {
  final bool _enableOpacity;
  bool get enableOpacity =>
      _enableOpacity && js.context['flutterCanvasKit'] != null;

  final bool enableLibrary;

  final bool _enableEyePicker;

  bool get enableEyePicker =>
      _enableEyePicker && js.context['flutterCanvasKit'] != null;

  const ColorPickerConfig({
    this.enableLibrary = true,
    bool enableOpacity = true,
    bool enableEyePicker = true,
  })  : _enableEyePicker = enableEyePicker,
        _enableOpacity = enableOpacity;
}
