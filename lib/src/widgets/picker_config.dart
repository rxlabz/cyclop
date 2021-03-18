/// Color picker config
/// allow to disable some part of the picker :
/// - [enableOpacity] : hide/show the opacity slider
/// - [enableLibrary] : hide/show the custom library tab
/// - [enableEyePicker] : hide/show the eyedropper button ( should be disabled in html renderer )
class ColorPickerConfig {
  final bool enableOpacity;

  final bool enableLibrary;

  final bool enableEyePicker;

  const ColorPickerConfig({
    this.enableOpacity = true,
    this.enableLibrary = true,
    this.enableEyePicker = true,
  });
}
