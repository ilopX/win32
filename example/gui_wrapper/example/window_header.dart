import 'dart:io';

import 'package:win32/win32.dart';

import '../src/app.dart' as app;
import '../src/base/window_header.dart';
import '../src/button.dart';
import '../src/window.dart';

class MainWindow extends Window {
  final buttons = {
    'No title': Button(),
    'No close': Button(x: 120),
    'Tool Box':Button(x: 240),
    'Dialog': Button(x: 360),
    'Full title': Button(x: 480),
  };

  MainWindow() : super(
    text: 'Window header example',
    center: true,
    visible: true,
  ) {
    initAndSetParentButtons();
  }

  @override
  int wndProc(int msg, int wParam, int lParam) {
    switch(msg) {
      case WM_COMMAND:
        onButtonsClick(lParam);
        return TRUE;
    }
    return super.wndProc(msg, wParam, lParam);
  }

  void onButtonsClick(int buttonWnd) {
    try {
      final button = buttonFrom(hWnd: buttonWnd);
      final windowHeader = windowHeaderFromText(button.text);
      this.windowHeader = windowHeader;
    } catch(e){
      stderr.writeln(e.toString());
    }
  }

  Button buttonFrom({required int hWnd}) => buttons.values.firstWhere(
          (button) => button.hWnd == hWnd
  );

  void initAndSetParentButtons() {
    for (final entry in buttons.entries) {
      final button = entry.value;
      final text = entry.key;
      button.setParent(this);
      button.visible = true;
      button.text = text;
    }
  }

  WindowHeader windowHeaderFromText(String text) {
    switch(text) {
      case 'No title':
        return WindowHeader.hide();
      case'No close':
        return WindowHeader.noClose();
      case'Tool Box':
        return WindowHeader.toolBox();
      case'Dialog':
        return WindowHeader.dialog();
      case'Full title':
        return WindowHeader.full();
      default:
        throw ArgumentError();
    }
  }
}

void main() {
  MainWindow();
  app.exec();
}

