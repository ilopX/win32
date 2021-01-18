import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '_app.dart' as app;
import '_tray.dart' as tray;

class MenuItem {
  final String text;
  final Function()? onAction;

  MenuItem({required this.text, this.onAction});
}

class ContextMenu {
  final int hWndParent;
  final List<MenuItem> children;

  final menuWmId = 1024;
  final int _timerDeregisterMenu = WM_APP + 1024;

  ContextMenu({
    required this.hWndParent,
    this.children = const <MenuItem>[]
  });

  void show(int x, int y) {
    app.registryWdnProc(_wndProc);
    SetForegroundWindow(hWndParent);

    final hMenu = _buildMenu();

    TrackPopupMenuEx(hMenu,
        _contextMenuFlags,
        x, y,
        hWndParent, nullptr);

    DestroyMenu(hMenu);
    SetTimer(hWndParent, _timerDeregisterMenu, 0, nullptr);
  }

  int _buildMenu() {
    final hMenu = CreateMenu();

    for(var i = 0; i < children.length; i++) {
      AppendMenu(hMenu, MF_STRING, _indexToId(i), TEXT(children[i].text));
    }

    final hMenubar = CreateMenu();
    AppendMenu(hMenubar, MF_POPUP, hMenu, TEXT("_contextMenu"));

    return GetSubMenu(hMenubar, 0);
  }

  bool _wndProc(int hWnd, int uMsg, int wParam, int lParam) {
    switch (uMsg) {
      case WM_COMMAND:
        final index = _idToIndex(LOWORD(wParam));
        if (children.length < index) {
          return false;
        }
        final action = children[index].onAction;
        return action?.call() != null;

      case WM_TIMER:
          if (_timerDeregisterMenu == wParam) {
            KillTimer(hWndParent, _timerDeregisterMenu);
            app.deregisterWndProc(_wndProc);
            return true;
        }
    }
    return false;
  }

  int _indexToId(int index) => index + WM_APP + menuWmId;

  int _idToIndex(int index) => index - WM_APP - menuWmId;
}


int get _contextMenuFlags  {
  var uFlags = TPM_RIGHTBUTTON;
  if (GetSystemMetrics(SM_MENUDROPALIGNMENT) != 0) {
    uFlags |= TPM_RIGHTALIGN;
  } else {
    uFlags |= TPM_LEFTALIGN;
  }
  return uFlags;
}
