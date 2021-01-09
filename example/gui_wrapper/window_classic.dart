import 'package:win32/win32.dart';
import 'src/app.dart';
import 'src/window.dart';

void main() {
  Window(
    text: 'Window example',
    center: true,
    visible: true,
    resize: true,
    onWndProc: (int uMsg, int wParam, int lParam) {
      switch(uMsg) {
        case WM_RBUTTONDOWN: {
          print('click');
          break;
        }
      }
    }
  );
  exec();
}

