import 'package:win32/win32.dart';
import 'src/app.dart' as app;
import 'src/base/win_control.dart';
import 'src/window.dart';

void main() {
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
          break;
        }
      }
    }
  );

  app.exec();
}

