import 'package:win32/win32.dart';

import 'base/dart_window_class.dart';
import 'base/win_control.dart';

class Window extends WinControl {
  Window({
    String text = 'Window',
    bool center = true,
    bool visible = true,
    bool resize = true,
  }) : _resize = resize,
        super(
          text: text,
          width: 640,
          height: 480,
          className: DartWindowClass.name,
          style: WS_OVERLAPPEDWINDOW
      ){
    if (center) {
      moveToCenter();
    }
    super.visible = visible;
    _updateStyle();
  }

  @override
  int createWindow() {
    DartWindowClass.register();
    return super.createWindow();
  }

  void moveToCenter() {
    final screenWidth = GetSystemMetrics(SM_CXFULLSCREEN);
    final screenHeight = GetSystemMetrics(SM_CYFULLSCREEN);
    x = (screenWidth - width) ~/ 2;
    y = (screenHeight - height) ~/ 2;
  }

  bool _resize;
  bool get resize => _resize;
  set resize(bool resize) {
    _resize = resize;
    _updateStyle();
  }

  void _updateStyle() {
    changeWindowFlag({
      WS_THICKFRAME: _resize,
    });
  }
}
