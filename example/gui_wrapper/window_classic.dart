import 'package:win32/win32.dart';
import 'src/app.dart' as app;
import 'src/base/win_control.dart';
import 'src/window.dart';

// old style
class MyWin extends Window {
  MyWin() :super(text: 'MyWin');

  @override
  int wndProc(int msg, int wParam, int lParam) {
    switch(msg) {
      case WM_MOUSEMOVE: {
        final x = LOWORD(lParam);
        final y = HIWORD(lParam);
        text = 'x: $x, y: $y';
        break;
      }
    }
    return super.wndProc(msg, wParam, lParam);
  }
}

void main() {
  // flutter  style
  final win =  Controller<Window>();
  final w = Window(
    controller: win,
    text: 'Window example',
    center: true,
    visible: true,
    resize: true,
    onWndProc: (int uMsg, int wParam, int lParam) {
      switch(uMsg) {
        case WM_RBUTTONDOWN: {
          win.control?.text = 'new Text';
          MyWin();
          break;
        }
      }
    }
  );

  app.exec();
}

