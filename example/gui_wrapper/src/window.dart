import 'package:win32/win32.dart';

import 'dart_window_class.dart';
import 'win_control.dart';

class Window extends WinControl{
  Window() : super(
      width: 640,
      height: 480,
      className: DartWindowClass.name,
      style: WS_OVERLAPPEDWINDOW + WS_VISIBLE
  );

  @override
  int createWindow() {
    DartWindowClass.register();
    return super.createWindow();
  }
}
