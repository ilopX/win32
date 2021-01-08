import 'package:win32/win32.dart';

import 'dart_window_class.dart';
import 'win_control.dart';

class Window extends WinControl{
  Window({
    String text = 'Window',
    bool center = true,
    bool visible = true,
  }) : super(
      text: text,
      width: 640,
      height: 480,
      className: DartWindowClass.name,
      style: WS_OVERLAPPEDWINDOW
  ) {
    if (center) {
      moveToCenter();
    }
    super.visible = visible;
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
}
