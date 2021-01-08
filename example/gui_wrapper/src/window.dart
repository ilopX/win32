import 'package:win32/win32.dart';

import 'dart_window_class.dart';
import 'win_control.dart';

class Window extends WinControl{
  Window({
    bool center = true,
  }) : super(
      width: 640,
      height: 480,
      className: DartWindowClass.name,
      style: WS_OVERLAPPEDWINDOW
  ) {
    if (center) {
      moveToCenter();
    }
    visible = true;
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
