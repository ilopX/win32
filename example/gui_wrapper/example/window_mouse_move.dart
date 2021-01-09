import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../src/app.dart' as app;
import '../src/base/win_control.dart';
import '../src/base/window_header.dart';
import '../src/inc.dart';
import '../src/window.dart';

void main() {
  final win =  Controller<Window>();
  Window(
    controller: win,
    text: 'Window example',
    center: true,
    visible: true,
    onWndProc: (int uMsg, int wParam, int lParam) {
      switch(uMsg) {
        case WM_RBUTTONDOWN:
          createMouseMoveDialogs(50, win.control);
          break;
        case WM_PAINT:
          drawText(win.control?.hWnd, win.control?.text);
          break;
      }
    }
  );

  app.exec();
}

class Dialog extends Window {
  final Window? mainWindow;

  Dialog({
    required this.mainWindow,
    required int x,
    required int y,
    required String text,
  }) :super(
    text: text,
    windowHeader: WindowHeader.hide(),
    resize: true,
    x: x,
    y: y,
    width: 200,
    height: 200,
    center: false,
  );

  @override
  int wndProc(int msg, int wParam, int lParam) {
    switch(msg) {
      case WM_MOUSEMOVE: {
        final x = LOWORD(lParam);
        final y = HIWORD(lParam);
        mainWindow?.text = 'MouseMove(x: $x, y: $y) - from $text';
        InvalidateRect(mainWindow?.hWnd ?? 0, nullptr, TRUE);
        break;
      }
    }
    return super.wndProc(msg, wParam, lParam);
  }
}

void createMouseMoveDialogs(int dialogCount, Window? mainWindow) {
  const startX = 800;
  const startY = 450;
  for (var i = 0; i < dialogCount + 1; i++) {
    //
    final radius = i / dialogCount * pi * 1.5;
    final x = startX + cos(radius) * startX / 2;
    final y = startY + sin(radius) * startY / 2;

    Dialog(
      mainWindow: mainWindow,
      x: x.toInt(),
      y: y.toInt(),
      text: 'Dialog №$i',
    );
  }
}

void drawText(int? hWnd, String? text) {
  if (hWnd == null || text == null) {
    return;
  }

  final rect = RECT.allocate();
  GetClientRect(hWnd, rect.addressOf);

  final ps = PAINTSTRUCT.allocate();
  final hdc = BeginPaint(hWnd, ps.addressOf);
  SelectObject(hdc, GetStockObject(DEFAULT_GUI_FONT));
  DrawText(hdc,  TEXT(text), -1, rect.addressOf,
      DT_CENTER | DT_VCENTER | DT_SINGLELINE
  );
  EndPaint(hWnd, ps.addressOf);

  free(ps.addressOf);
  free(rect.addressOf);
}
