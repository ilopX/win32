import 'dart:ffi';

import 'package:win32/win32.dart';

import '_inc.dart';
import 'app.dart';

abstract class WinControl {
  WinControl({
    required this.className,
    String text = 'None',
    int x = 10,
    int y = 10,
    int width = 50,
    int height = 15,
    this.style = WS_THICKFRAME | WS_SYSMENU,
  }) :  _text = text,
        _x = x,
        _y = y,
        _width = width,
        _height = height {
    _hWnd = createWindow();
  }

  final String className;

  int _hWnd = 0;
  int get hWnd => _hWnd;

  final int style;

  int createWindow() => CreateWindowEx(0,
      TEXT(className),
      TEXT(_text),
      style,
      _x,
      _y,
      _width,
      _height,
      0,
      0,
      hInst,
      nullptr
  );

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

  void setParent(WinControl parent) {
    SetParent(_hWnd, parent._hWnd);
    SetWindowLongPtr(_hWnd, GWL_STYLE, WS_TABSTOP | WS_CHILD);
    _updateSize();
    ShowWindow(_hWnd, visible ? SW_SHOW : SW_HIDE);
  }
}
