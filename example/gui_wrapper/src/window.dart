import 'package:win32/win32.dart';

import 'app.dart';
import 'base/dart_window_class.dart';
import 'base/win_control.dart';
import 'base/window_header.dart';
import 'inc.dart';

class Window extends WinControl {
  Window({
    String text = 'Window',
    bool center = true,
    bool visible = true,
    bool resize = true,
    WindowHeader windowHeader = const WindowHeader(),
    WndProcControl? onWndProc,
    Controller<Window>? controller,
  }) :  _resize = resize,
        _windowHeader = windowHeader,
        super(
          text: text,
          width: 640,
          height: 480,
          className: DartWindowClass.name,
          style: WS_OVERLAPPEDWINDOW,
          onWndProc: onWndProc,
          controller: controller
      ){
    if (center) {
      moveToCenter();
    }
     _updateStyle();
    super.visible = visible;
  }

  WindowHeader _windowHeader;
  WindowHeader get windowHeader => _windowHeader;
  set windowHeader(WindowHeader newWindowHeader) {
    _windowHeader = newWindowHeader;
    _updateStyle();
  }

  @override
  int createWindow() {
    DartWindowClass.register();
    final hwnd = super.createWindow();
    windows[hwnd] = this;
    return hwnd;
  }

  void moveToCenter() {
    final screenWidth = GetSystemMetrics(SM_CXFULLSCREEN);
    final screenHeight = GetSystemMetrics(SM_CYFULLSCREEN);
    x = (screenWidth - width) ~/ 2;
    y = (screenHeight - height) ~/ 2;
  }

  bool _resize;
  bool get resize => _resize;
  set resize(bool resize) {
    _resize = resize;
    _updateStyle();
  }

  void _updateStyle() {
    updateWindowFlag(GWL_STYLE, {
      WS_OVERLAPPEDWINDOW: true,
      WS_MINIMIZEBOX: _windowHeader.minimizeBox,
      WS_MAXIMIZEBOX: _windowHeader.maximizeBox,
      WS_SYSMENU: _windowHeader.closeBox,
      WS_CAPTION: _windowHeader.visible,
      WS_THICKFRAME: _resize,
    });

    updateWindowFlag(GWL_EXSTYLE, {
      WS_EX_TOOLWINDOW: _windowHeader.toolBox,
    });
  }
}
