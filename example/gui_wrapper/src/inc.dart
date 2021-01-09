import 'dart:ffi';
import 'package:ffi/ffi.dart';

// typedef struct tagWNDCLASSEXW {
// UINT      cbSize;
// UINT      style;
// WNDPROC   lpfnWndProc;
// int       cbClsExtra;
// int       cbWndExtra;
// HINSTANCE hInstance;
// HICON     hIcon;
// HCURSOR   hCursor;
// HBRUSH    hbrBackground;
// LPCWSTR   lpszMenuName;
// LPCWSTR   lpszClassName;
// HICON     hIconSm;
// } WNDCLASSEXW, *PWNDCLASSEXW, *NPWNDCLASSEXW, *LPWNDCLASSEXW;

/// Contains window class information. It is used with the RegisterClassEx
/// and GetClassInfoEx  functions.
/// {@category Struct}

class WNDCLASSEX extends Struct {
  @Int32()
  external int cbSize;

  @Uint32()
  external int style;

  external Pointer<NativeFunction> lpfnWndProc;

  @Int32()
  external int cbClsExtra;

  @Int32()
  external int cbWndExtra;

  @IntPtr()
  external int hInstance;

  @IntPtr()
  external int hIcon;

  @IntPtr()
  external int hCursor;

  @IntPtr()
  external int hbrBackground;

  external Pointer<Utf16> lpszMenuName;
  external Pointer<Utf16> lpszClassName;

  @IntPtr()
  external int hIconSm;

  factory WNDCLASSEX.allocate() => allocate<WNDCLASSEX>().ref
    ..cbSize = sizeOf<WNDCLASSEX>()
    ..style = 0
    ..lpfnWndProc = nullptr
    ..cbClsExtra = 0
    ..cbWndExtra = 0
    ..hInstance = 0
    ..hIcon = 0
    ..hCursor = 0
    ..hbrBackground = 0
    ..lpszMenuName = nullptr
    ..lpszClassName = nullptr
    ..hIconSm = 0;

}

final _user32 = DynamicLibrary.open('user32.dll');
int RegisterClassEx(Pointer<WNDCLASSEX> lpWndClass) {
  final _RegisterClassEx = _user32.lookupFunction<
      Int16 Function(Pointer<WNDCLASSEX> lpWndClass),
      int Function(Pointer<WNDCLASSEX> lpWndClass)>('RegisterClassExW');
  return _RegisterClassEx(lpWndClass);
}

const GWL_STYLE = -16;
const GWL_EXSTYLE = -20;
// Retrieves information about the specified window. The function also retrieves
// the value at a specified offset into the extra window memory.

// LONG_PTR GetWindowLongPtrW(
//     HWND hWnd,
//     int  nIndex
//     );
int GetWindowLongPtr(int hWnd, int nIndex) {
  final _getWindowLongPtr = _user32.lookupFunction<
      IntPtr Function(Int32, Int32),
      int Function(int, int)>('GetWindowLongPtrW');
  return _getWindowLongPtr(hWnd, nIndex);
}
