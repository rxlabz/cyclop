import '../../cyclop.dart';

class ColorButtonController {
  ColorButtonState? colorButtonState;

  void removeOverlay() {
    colorButtonState?.removeOverlay();
  }
}
