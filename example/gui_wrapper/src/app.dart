import 'dart:ffi';

import 'package:win32/win32.dart';

var onClickWindow = (){};

final int hInst = GetModuleHandle(nullptr);

final Pointer<NativeFunction> appWndProc = Pointer
    .fromFunction<WindowProc>(_appWindowProc, 0);

void exec() {
  final msg = MSG.allocate();
  while (GetMessage(msg.addressOf, NULL, 0, 0) != 0) {
    TranslateMessage(msg.addressOf);
    DispatchMessage(msg.addressOf);
  }
}

int _appWindowProc(int hWnd, int uMsg, int wParam, int lParam) {
  switch (uMsg) {
    case WM_DESTROY: {
      PostQuitMessage(0);
      return 0;
    }
    case WM_LBUTTONDOWN:{
      onClickWindow();
      break;
    }

  }
  return DefWindowProc(hWnd, uMsg, wParam, lParam);
}
