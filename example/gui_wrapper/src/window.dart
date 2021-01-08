import 'dart:ffi';
import 'package:win32/win32.dart';

import '_inc.dart';
import 'app.dart';

class Window {
  Window() {
    const className = 'Dart_Window_Class';
    registerWindow(className);
    createWindow(className);
  }
}

int registerWindow(String className) {
  final wndClass = WNDCLASSEX.allocate();
  wndClass.style = CS_HREDRAW | CS_VREDRAW;
  wndClass.lpfnWndProc = appWndProc;
  wndClass.hInstance = hInst;
  wndClass.hIcon = LoadIcon(NULL, IDI_APPLICATION);
  wndClass.hCursor = LoadCursor(NULL, IDC_ARROW);
  wndClass.hbrBackground = COLOR_WINDOW + 1;
  wndClass.lpszMenuName = nullptr;
  wndClass.lpszClassName = TEXT(className);
  return RegisterClassEx(wndClass.addressOf);
}

int createWindow(String className) {
  const width = 640;
  const height = 480;

  final screenWidth = GetSystemMetrics(SM_CXFULLSCREEN);
  final screenHeight = GetSystemMetrics(SM_CYFULLSCREEN);
  final x = (screenWidth - width) ~/ 2;
  final y = (screenHeight - height) ~/ 2;


  final window = CreateWindowEx(
      0,
      TEXT(className),
      TEXT('title'),
      WS_OVERLAPPEDWINDOW + WS_VISIBLE,
      x,
      y,
      width,
      height,
      NULL,
      NULL,
      hInst,
      nullptr);

  return window;
}
