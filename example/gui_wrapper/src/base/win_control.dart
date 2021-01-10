import 'dart:ffi';

import 'package:win32/win32.dart';

import '../app.dart';
import '../inc.dart';
import '../utilities/flags.dart';

class Controller<T extends WinControl> {
  T? _control;
  T? get control => _control;
  Controller();
}

abstract class WinControl {
  WinControl({
    required this.className,
    String text = 'None',
    int x = 10,
    int y = 10,
    int width = 50,
    int height = 15,
    this.style = WS_THICKFRAME | WS_SYSMENU,
    this.onWndProc,
    Controller? controller,
    WinControl? parent,
  }) :  _text = text,
        _x = x,
        _y = y,
        _width = width,
        _height = height {
    _hWnd = createWindow(hWndParent: parent?.hWnd ?? 0);
    SendMessage(_hWnd, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT), FALSE);
    controller?._control = this;
  }

  final String className;

  int _hWnd = 0;
  int get hWnd => _hWnd;

  final int style;

  int createWindow({int hWndParent = 0}) => CreateWindowEx(0,
      TEXT(className),
      TEXT(_text),
      style,
      _x,
      _y,
      _width,
      _height,
      hWndParent,
      0,
      hInst,
      nullptr
  );

  // TODO: add correct x, y, width getters
  // TODO: add positional method

  int _x;
  int get x  => _x;
  set x (int newX) {
    _x = newX;
    _updateSize();
  }

  int _y;
  int get y  => _y;
  set y (int newY) {
    _y = newY;
    _updateSize();
  }

  int _width;
  int get width  => _width;
  set width (int newWidth) {
    _width = newWidth;
    _updateSize();
  }

  int _height;
  int get height  => _height;
  set height (int newHeight) {
    _height = newHeight;
    _updateSize();
  }

  bool get visible  => IsWindowVisible(_hWnd) == 1;
  set visible (bool newVisible) {
    ShowWindow(_hWnd, newVisible ? SW_SHOW : SW_HIDE);
  }

  String _text;
  String get text {
    // final  textBuff = Utf16.toUtf16(' '.padLeft(256));
    // GetWindowText(hWnd, textBuff, 256);
    // _text = textBuff.unpackString(256);
    // free(textBuff);
    return _text;
  }

  set text(String newText) {
    _text = newText;
    SetWindowText(_hWnd, TEXT(newText));
  }

  void _updateSize() {
    MoveWindow(_hWnd, _x, _y, _width, _height, TRUE);
  }

  // TODO: replace by property
  void setParent(WinControl parent) {
    ShowWindow(_hWnd, SW_HIDE);
    updateWindowFlag(GWL_STYLE, {
      WS_OVERLAPPEDWINDOW: false,
      WS_TABSTOP: true,
      WS_CHILD: true,
    });
    SetParent(_hWnd, parent._hWnd);
    _updateSize();
    ShowWindow(_hWnd, visible ? SW_SHOW : SW_HIDE);
  }

  void updateWindowFlag(int gwlFlag, Map<int, bool> flagsExpressionMap) {
    WinFlag(this, gwlFlag)
      ..addOrRemoveFlags(flagsExpressionMap)
      ..apply();
  }

  WndProcControl ?onWndProc;

  int wndProc(int msg, int wParam, int lParam) {
    onWndProc?.call(msg, wParam, lParam);
    return FALSE;
  }
}

class WinFlag  extends Flags {
  final int hWnd;
  final int type;

  WinFlag(WinControl window, this.type)
      : hWnd = window.hWnd,
        super(initFlags: GetWindowLongPtr(window.hWnd, type));

  void apply() {
    SetWindowLongPtr(hWnd, type, flags);
  }
}
