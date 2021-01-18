import 'package:win32/win32.dart';

import '_app.dart' as app;
import '_menu.dart' as menu;
import '_menu.dart';
import '_tray.dart';
import '_window.dart' as window;

void main() {
  TrayNotifyIcon ?tray;
  final hWnd = window.createHidden();

  void switchWindowVisible() {
    ShowWindow(hWnd, IsWindowVisible(hWnd) == 1
        ? SW_HIDE
        : SW_SHOW);
    SetForegroundWindow(hWnd);
  }

  final contextMenu = ContextMenu(
    hWndParent: hWnd,
    children: [
      MenuItem(
        text: 'Show/Hide window',
        onAction: () {
          switchWindowVisible();
        },
      ),
      MenuItem(
        text: '&Quit',
        onAction: () {
          tray?.hide();
          PostQuitMessage(0);
        }
      ),
    ]
  );

  tray = TrayNotifyIcon(
    hWndParent: hWnd,
    icon: app.loadDartIcon(),
    onSelect: () {
      switchWindowVisible();
    },
    onContextMenu: (x, y) {
      contextMenu.show(x, y);
    }
  )..show();

  app.exec();
}

