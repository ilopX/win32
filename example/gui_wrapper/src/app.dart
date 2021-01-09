import 'dart:ffi';

import 'package:win32/win32.dart';

import 'window.dart';

typedef WndProcControl = void Function(int msg, int wParam, int lParam);

final int hInst = GetModuleHandle(nullptr);

final Pointer<NativeFunction> appWndProc = Pointer
    .fromFunction<WindowProc>(_appWindowProc, 0);

 final windows = <int, Window>{};

void exec() {
  final msg = MSG.allocate();
  while (GetMessage(msg.addressOf, NULL, 0, 0) != 0) {
    TranslateMessage(msg.addressOf);
    DispatchMessage(msg.addressOf);
  }
}

int _appWindowProc(int hWnd, int msg, int wParam, int lParam) {
  switch (msg) {
    case WM_DESTROY: {
      PostQuitMessage(0);
      return 0;
    }
  }

  windows[hWnd]?.wndProc(msg, wParam, lParam);

  return DefWindowProc(hWnd, msg, wParam, lParam);
}
