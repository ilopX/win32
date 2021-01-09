import 'dart:ffi';

import 'package:win32/win32.dart';

import '../app.dart';
import '../inc.dart';

// ignore: avoid_classes_with_only_static_members
class DartWindowClass {
  static String name = 'Dart_Window_Class';
  static int _classInst = 0;

  static int register() {
    if (!isRegistered) {
      _classInst = _registerNewWindowClass();
    }
    return _classInst;
  }

  static int _registerNewWindowClass() {
    final wndClass = WNDCLASSEX.allocate();
    wndClass.style = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
    wndClass.lpfnWndProc = appWndProc;
    wndClass.hInstance = hInst;
    wndClass.hIcon = LoadIcon(NULL, IDI_APPLICATION);
    wndClass.hCursor = LoadCursor(NULL, IDC_ARROW);
    wndClass.hbrBackground = COLOR_WINDOW + 1;
    wndClass.lpszMenuName = nullptr;
    wndClass.lpszClassName = TEXT(name);
    return RegisterClassEx(wndClass.addressOf);
  }

  static bool get isRegistered => _classInst != 0;
}
