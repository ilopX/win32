import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final hInst = GetModuleHandle(nullptr);

const EVENT_QUIT = WM_APP + 2;
const EVENT_TRAY_NOTIFY = WM_APP + 1;

typedef LocalWndProc = bool Function(int hWnd,
    int uMsg, int wParam, int lParam);


final wndProc = Pointer.fromFunction<WindowProc>(_appWndProc, 0);

int exec() {
  final msg = calloc<MSG>();
  while (GetMessage(msg, NULL, 0, 0) != 0) {
    TranslateMessage(msg);
    DispatchMessage(msg);
  }
  return msg.ref.lParam;
}

int loadDartIcon() {
  final dartIconPath = _thisPath('dart.ico');
  return LoadImage(
      0,
      TEXT(dartIconPath),
      IMAGE_ICON,
      0,
      0,
      LR_LOADFROMFILE | LR_DEFAULTSIZE | LR_SHARED
  );
}

final _localWndProcs = <LocalWndProc>[];

/// Use in iterateLocalWndProcs
void registryWdnProc(LocalWndProc proc) => _localWndProcs.add(proc);

void deregisterWndProc(LocalWndProc proc) {
  _localWndProcs.remove(proc);
}
int _appWndProc(int hWnd, int uMsg, int wParam, int lParam) {
  if (iterateLocalWndProcs(hWnd, uMsg, wParam, lParam)) {
    return TRUE;
  }

  return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

bool iterateLocalWndProcs(int hWnd, int uMsg, int wParam, int lParam) {
  for(final proc in _localWndProcs) {
    final isProcProcessed = proc(hWnd, uMsg, wParam, lParam);
    if (isProcProcessed) {
      return true;
    }
  }
  return false;
}

String _thisPath(String fileName) =>  Platform.script
    .toFilePath()
    .replaceFirst(RegExp(r'[^\\]+$'), fileName);

Point<int> getMousePos() {
  final point = calloc<POINT>();
  GetCursorPos(point);
  final result = Point(point.ref.x, point.ref.y);
  free(point);
  return result;
}
