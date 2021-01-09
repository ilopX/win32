import 'src/app.dart';
import 'src/window.dart';

void main() {
  Window(
    text: 'Window example',
    center: true,
    visible: true,
    resize: true,
    windowHeader: WindowHeader.full()
    // startMinimize: false,
    // startMaximize: false,
    // showInTaskPanel: false,
    // resize: true,
    // onPaint: (GdiPlusGraph graph) {}
    // wndProc: (int hWnd, int uMsg, int wParam, int lParam) {
    //   return DefWindowProc(hWnd, Msg, wParam, lParam);
    // }
  );
  exec();
}

