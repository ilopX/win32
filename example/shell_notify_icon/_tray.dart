import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '_app.dart' as app;
import '_app.dart';
import '_menu.dart' as menu;

class TrayNotifyIcon {
  final String toolTip;
  final int hIcon;
  final int hWndParent;

  TrayNotifyIcon({
    required this.hWndParent,
    int icon = 0,
    this.toolTip = '',
    this.onWndProc,
    this.onSelect,
    this.onContextMenu,
  }) : hIcon = icon == 0 ? LoadIcon(NULL, IDI_APPLICATION) : icon;

  app.LocalWndProc? onWndProc;
  Function()? onSelect;
  Function(int x, int y)? onContextMenu;

  void show() {
    _nid ??= _allocNotifyIconData();
    app.registryWdnProc(trayWndProc);
    Shell_NotifyIcon(NIM_ADD, _nid!);
  }

  void hide() {
    if (_nid == null) {
      return;
    }

    Shell_NotifyIcon(NIM_DELETE, _nid!);
    free(_nid!);
    app.deregisterWndProc(trayWndProc);
  }

  bool trayWndProc(int hWnd, int msg, int wParam, int lParam)  {
    if (msg == app.EVENT_TRAY_NOTIFY) {
      final trayMsg = _fixNotifyDataToVersion4(LOWORD(lParam));
      switch (trayMsg) {
        case NIN_SELECT:
          return onSelect!.call() != null;

        case WM_CONTEXTMENU:
          final pos = getMousePos();
          return onContextMenu?.call(pos.x, pos.y) != null;
      }
    }
    return onWndProc?.call(hWnd, msg, wParam, lParam) ?? false;
  }

  Pointer<NOTIFYICONDATA>? _nid;

  Pointer<NOTIFYICONDATA> _allocNotifyIconData() {
    final pNid = calloc<NOTIFYICONDATA>();
    final nid = pNid.ref;
    nid.cbSize =  sizeOf<NOTIFYICONDATA>();
    nid.hWnd = hWndParent;
    nid.uFlags = NIF_ICON | NIF_TIP | NIF_MESSAGE | NIF_SHOWTIP | NIF_GUID;
    pNid.szTip = toolTip;
    nid.uCallbackMessage = app.EVENT_TRAY_NOTIFY;
    nid.hIcon = hIcon;
    return pNid;
  }
}

int _fixNotifyDataToVersion4(int msg) {
  switch(msg) {
    case 521: return WM_MBUTTONDBLCLK;
    case 520: return WM_MBUTTONUP;
    case 519: return WM_MBUTTONDOWN;
    case 517: return WM_CONTEXTMENU;
    case 516: return WM_RBUTTONDOWN;
    case 515: return WM_LBUTTONDBLCLK;
    case 514: return NIN_SELECT;
    case 513: return WM_LBUTTONDOWN;
    case 512: return WM_MOUSEMOVE;
  }
  return msg;
}
