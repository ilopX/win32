// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart representations of common structs used in the Win32 API

// -----------------------------------------------------------------------------
// Linter exceptions
// -----------------------------------------------------------------------------
// ignore_for_file: camel_case_types
// ignore_for_file: camel_case_extensions
// Why? The linter defaults to throw a warning for types not named as camel
// case. We deliberately break this convention to match the Win32 underlying
// types.
//
// ignore_for_file: unused_field
// Why? The linter complains about unused fields (e.g. a class that contains
// underscore-prefixed members that are not used in the library. In this class,
// we use this feature to ensure that sizeOf<STRUCT_NAME> returns a size at
// least as large as the underlying native struct. See, for example,
// ENUMLOGFONTEX.
// -----------------------------------------------------------------------------

import 'dart:ffi';
import 'dart:math' show min;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'callbacks.dart';
import 'constants.dart';
import 'constants_nodoc.dart';
import 'extensions/unpack_utf16.dart';
import 'kernel32.dart';
import 'oleaut32.dart';

Pointer<T> calloc<T extends NativeType>({int count = 1}) {
  final totalSize = count * sizeOf<T>();
  final heap = GetProcessHeap();

  if (heap != NULL) {
    final result = HeapAlloc(heap, HEAP_ZERO_MEMORY, totalSize);

    if (result.address != 0) {
      return result.cast<T>();
    }
  }

  throw ArgumentError('Unable to allocate required memory.');
}

// typedef struct tagWNDCLASSW {
//   UINT      style;
//   WNDPROC   lpfnWndProc;
//   int       cbClsExtra;
//   int       cbWndExtra;
//   HINSTANCE hInstance;
//   HICON     hIcon;
//   HCURSOR   hCursor;
//   HBRUSH    hbrBackground;
//   LPCWSTR   lpszMenuName;
//   LPCWSTR   lpszClassName;
// } WNDCLASSW, *PWNDCLASSW, *NPWNDCLASSW, *LPWNDCLASSW;

/// Contains the window class attributes that are registered by the
/// RegisterClass function.
///
/// {@category Struct}
class WNDCLASS extends Struct {
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
}

// typedef struct _SYSTEM_INFO {
//   union {
//     DWORD dwOemId;
//     struct {
//       WORD wProcessorArchitecture;
//       WORD wReserved;
//     } DUMMYSTRUCTNAME;
//   } DUMMYUNIONNAME;
//   DWORD     dwPageSize;
//   LPVOID    lpMinimumApplicationAddress;
//   LPVOID    lpMaximumApplicationAddress;
//   DWORD_PTR dwActiveProcessorMask;
//   DWORD     dwNumberOfProcessors;
//   DWORD     dwProcessorType;
//   DWORD     dwAllocationGranularity;
//   WORD      wProcessorLevel;
//   WORD      wProcessorRevision;
// } SYSTEM_INFO, *LPSYSTEM_INFO;

/// Contains information about the current computer system. This includes the
/// architecture and type of the processor, the number of processors in the
/// system, the page size, and other such information.
///
/// {@category Struct}
class SYSTEM_INFO extends Struct {
  @Uint16()
  external int wProcessorArchitecture;

  @Uint16()
  external int wReserved;

  @Uint32()
  external int dwPageSize;

  external Pointer lpMinimumApplicationAddress;
  external Pointer lpMaximumApplicationAddress;

  @IntPtr()
  external int dwActiveProcessorMask;

  @Uint32()
  external int dwNumberOfProcessors;

  @Uint32()
  external int dwProcessorType;

  @Uint32()
  external int dwAllocationGranularity;

  @Uint16()
  external int wProcessorLevel;

  @Uint16()
  external int wProcessorRevision;
}

// typedef struct _PROCESS_INFORMATION {
//   HANDLE hProcess;
//   HANDLE hThread;
//   DWORD  dwProcessId;
//   DWORD  dwThreadId;
// } PROCESS_INFORMATION, *PPROCESS_INFORMATION, *LPPROCESS_INFORMATION;

/// Contains information about a newly created process and its primary thread.
/// It is used with the CreateProcess, CreateProcessAsUser,
/// CreateProcessWithLogonW, or CreateProcessWithTokenW function.
///
/// {@category Struct}
class PROCESS_INFORMATION extends Struct {
  @IntPtr()
  external int hProcess;
  @IntPtr()
  external int hThread;
  @Uint32()
  external int dwProcessId;
  @Uint32()
  external int dwThreadId;
}

// typedef struct _STARTUPINFOW {
//   DWORD  cb;
//   LPWSTR lpReserved;
//   LPWSTR lpDesktop;
//   LPWSTR lpTitle;
//   DWORD  dwX;
//   DWORD  dwY;
//   DWORD  dwXSize;
//   DWORD  dwYSize;
//   DWORD  dwXCountChars;
//   DWORD  dwYCountChars;
//   DWORD  dwFillAttribute;
//   DWORD  dwFlags;
//   WORD   wShowWindow;
//   WORD   cbReserved2;
//   LPBYTE lpReserved2;
//   HANDLE hStdInput;
//   HANDLE hStdOutput;
//   HANDLE hStdError;
// } STARTUPINFOW, *LPSTARTUPINFOW;

/// Specifies the window station, desktop, standard handles, and appearance of
/// the main window for a process at creation time.
///
/// {@category Struct}
class STARTUPINFO extends Struct {
  @Uint32()
  external int cb;
  external Pointer<Utf16> lpReserved;
  external Pointer<Utf16> lpDesktop;
  external Pointer<Utf16> lpTitle;
  @Uint32()
  external int dwX;
  @Uint32()
  external int dwY;
  @Uint32()
  external int dwXSize;
  @Uint32()
  external int dwYSize;
  @Uint32()
  external int dwXCountChars;
  @Uint32()
  external int dwYCountChars;
  @Uint32()
  external int dwFillAttribute;
  @Uint32()
  external int dwFlags;
  @Uint16()
  external int wShowWindow;
  @Uint16()
  external int cbReserved2;
  external Pointer<Uint8> lpReserved2;
  @IntPtr()
  external int hStdInput;
  @IntPtr()
  external int hStdOutput;
  @IntPtr()
  external int hStdError;

  factory STARTUPINFO.allocate() =>
      calloc<STARTUPINFO>().ref..cb = sizeOf<STARTUPINFO>();
}

// typedef struct tagBIND_OPTS
//     {
//     DWORD cbStruct;
//     DWORD grfFlags;
//     DWORD grfMode;
//     DWORD dwTickCountDeadline;
//     } 	BIND_OPTS;

/// Contains parameters used during a moniker-binding operation.
///
/// {@Category Struct}
class BIND_OPTS extends Struct {
  @Uint32()
  external int cbStruct;
  @Uint32()
  external int grfFlags;
  @Uint32()
  external int grfMode;
  @Uint32()
  external int dwTickCountDeadline;
}

// typedef struct _SYSTEM_POWER_STATUS {
//   BYTE  ACLineStatus;
//   BYTE  BatteryFlag;
//   BYTE  BatteryLifePercent;
//   BYTE  SystemStatusFlag;
//   DWORD BatteryLifeTime;
//   DWORD BatteryFullLifeTime;
// } SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS;

/// Contains information about the power status of the system.
///
/// {@category Struct}
class SYSTEM_POWER_STATUS extends Struct {
  @Uint8()
  external int ACLineStatus;
  @Uint8()
  external int BatteryFlag;
  @Uint8()
  external int BatteryLifePercent;
  @Uint8()
  external int SystemStatusFlag;
  @Uint32()
  external int BatteryLifeTime;
  @Uint32()
  external int BatteryFullLifeTime;
}

// typedef struct {
//     BOOLEAN             AcOnLine;
//     BOOLEAN             BatteryPresent;
//     BOOLEAN             Charging;
//     BOOLEAN             Discharging;
//     BOOLEAN             Spare1[3];

//     BYTE                Tag;

//     DWORD               MaxCapacity;
//     DWORD               RemainingCapacity;
//     DWORD               Rate;
//     DWORD               EstimatedTime;

//     DWORD               DefaultAlert1;
//     DWORD               DefaultAlert2;
// } SYSTEM_BATTERY_STATE, *PSYSTEM_BATTERY_STATE;

/// Contains information about the current state of the system battery.
///
/// {@category Struct}
class SYSTEM_BATTERY_STATE extends Struct {
  @Uint8()
  external int AcOnLine;
  @Uint8()
  external int BatteryPresent;
  @Uint8()
  external int Charging;
  @Uint8()
  external int Discharging;

  @Uint8()
  external int Spare1a;
  @Uint8()
  external int Spare1b;
  @Uint8()
  external int Spare1c;

  @Uint8()
  external int Tag;

  @Uint32()
  external int MaxCapacity;
  @Uint32()
  external int RemainingCapacity;
  @Uint32()
  external int Rate;
  @Uint32()
  external int EstimatedTime;

  @Uint32()
  external int DefaultAlert1;
  @Uint32()
  external int DefaultAlert2;
}

// typedef struct _STARTUPINFOEXW {
//   STARTUPINFOW                 StartupInfo;
//   LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList;
// } STARTUPINFOEXW, *LPSTARTUPINFOEXW;

/// Specifies the window station, desktop, standard handles, and attributes for
/// a new process. It is used with the CreateProcess and CreateProcessAsUser
/// functions.
///
/// {@category Struct}
class STARTUPINFOEX extends Struct {
  @Uint32()
  external int cb;
  external Pointer<Utf16> lpReserved;
  external Pointer<Utf16> lpDesktop;
  external Pointer<Utf16> lpTitle;
  @Uint32()
  external int dwX;
  @Uint32()
  external int dwY;
  @Uint32()
  external int dwXSize;
  @Uint32()
  external int dwYSize;
  @Uint32()
  external int dwXCountChars;
  @Uint32()
  external int dwYCountChars;
  @Uint32()
  external int dwFillAttribute;
  @Uint32()
  external int dwFlags;
  @Uint16()
  external int wShowWindow;
  @Uint16()
  external int cbReserved2;
  external Pointer<Uint8> lpReserved2;
  @IntPtr()
  external int hStdInput;
  @IntPtr()
  external int hStdOutput;
  @IntPtr()
  external int hStdError;
  external Pointer lpAttributeList;

  factory STARTUPINFOEX.allocate() =>
      calloc<STARTUPINFOEX>().ref..cb = sizeOf<STARTUPINFOEX>();
}

// typedef struct _SECURITY_ATTRIBUTES {
//   DWORD  nLength;
//   LPVOID lpSecurityDescriptor;
//   BOOL   bInheritHandle;
// } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

/// The SECURITY_ATTRIBUTES structure contains the security descriptor for an
/// object and specifies whether the handle retrieved by specifying this
/// structure is inheritable.
///
/// This structure provides security settings for objects created by various
/// functions, such as CreateFile, CreatePipe, CreateProcess, RegCreateKeyEx, or
/// RegSaveKeyEx.
///
/// {@category Struct}
class SECURITY_ATTRIBUTES extends Struct {
  @Uint32()
  external int nLength;

  external Pointer<Void> lpSecurityDescriptor;

  @Int32()
  external int bInheritHandle;
}

// typedef struct _SECURITY_DESCRIPTOR {
//   BYTE                        Revision;
//   BYTE                        Sbz1;
//   SECURITY_DESCRIPTOR_CONTROL Control;
//   PSID                        Owner;
//   PSID                        Group;
//   PACL                        Sacl;
//   PACL                        Dacl;
// } SECURITY_DESCRIPTOR, *PISECURITY_DESCRIPTOR;

/// The SECURITY_DESCRIPTOR structure contains the security information
/// associated with an object. Applications use this structure to set and query
/// an object's security status.
///
/// {@category Struct}
class SECURITY_DESCRIPTOR extends Struct {
  @Uint8()
  external int Revision;

  @Uint8()
  external int Sbz1;

  @Int16()
  external int Control;

  external Pointer<IntPtr> Owner;
  external Pointer<IntPtr> Group;
  external Pointer<IntPtr> Sacl;
  external Pointer<IntPtr> Dacl;
}

// typedef struct tagSOLE_AUTHENTICATION_SERVICE {
//   DWORD   dwAuthnSvc;
//   DWORD   dwAuthzSvc;
//   OLECHAR *pPrincipalName;
//   HRESULT hr;
// } SOLE_AUTHENTICATION_SERVICE;

/// Identifies an authentication service that a server is willing to use to
/// communicate to a client.
///
/// {@category Struct}
class SOLE_AUTHENTICATION_SERVICE extends Struct {
  @Uint32()
  external int dwAuthnSvc;

  @Uint32()
  external int dwAuthzSvc;

  external Pointer<Utf16> pPrincipalName;

  @Int32()
  external int hr;
}

// struct tagVARIANT
//    {
//        VARTYPE vt;
//        WORD wReserved1;
//        WORD wReserved2;
//        WORD wReserved3;
//        union
//            {
//            LONGLONG llVal;
//            LONG lVal;
//            BYTE bVal;
//            SHORT iVal;
//            ...
//    } ;

/// The VARIANT type is used in Win32 to represent a dynamic type. It is
/// represented as a struct containing a union of the types that could be
/// stored.
///
/// VARIANTs must be initialized with [VariantInit] before their use.

/// {@category Struct}

class VARIANT extends Struct {
  // The size of a union type equals the largest member it can contain, which in
  // the case of VARIANT is a struct of two pointers (BRECORD).

  @Uint16()
  external int vt;
  @Uint16()
  external int wReserved1;
  @Uint16()
  external int wReserved2;
  @Uint16()
  external int wReserved3;

  external Pointer ptr;
  external Pointer ptr2;

  bool get isPointer => vt & VARENUM.VT_PTR == VARENUM.VT_PTR;

  factory VARIANT.allocate() => calloc<VARIANT>().ref;

  factory VARIANT.fromPointer(Pointer ptr) => VARIANT.allocate()
    ..vt = VARENUM.VT_PTR
    ..ptr = ptr;
}

// typedef struct _COMDLG_FILTERSPEC {
//   LPCWSTR pszName;
//   LPCWSTR pszSpec;
// } COMDLG_FILTERSPEC;

/// Used generically to filter elements.
///
/// {@category Struct}
class COMDLG_FILTERSPEC extends Struct {
  external Pointer<Utf16> pszName;
  external Pointer<Utf16> pszSpec;
}

// typedef struct tagACCEL {
//     BYTE   fVirt;               /* Also called the flags field */
//     WORD   key;
//     WORD  cmd;
// } ACCEL, *LPACCEL;

/// Defines an accelerator key used in an accelerator table.
///
/// {@category Struct}
class ACCEL extends Struct {
  @Uint8()
  external int fVirt;
  @Uint16()
  external int key;
  @Uint16()
  external int cmd;
}

// typedef struct tagMONITORINFO {
//   DWORD cbSize;
//   RECT  rcMonitor;
//   RECT  rcWork;
//   DWORD dwFlags;
// } MONITORINFO, *LPMONITORINFO;

/// The MONITORINFO structure contains information about a display monitor.
///
/// {@category Struct}
class MONITORINFO extends Struct {
  @Uint32()
  external int cbSize;

  external RECT rcMonitor;
  external RECT rcWork;

  @Uint32()
  external int dwFlags;

  factory MONITORINFO.allocate() =>
      calloc<MONITORINFO>().ref..cbSize = sizeOf<MONITORINFO>();
}

const PHYSICAL_MONITOR_DESCRIPTION_SIZE = 128;

// typedef struct _PHYSICAL_MONITOR {
//   HANDLE hPhysicalMonitor;
//   WCHAR  szPhysicalMonitorDescription[PHYSICAL_MONITOR_DESCRIPTION_SIZE];
// } PHYSICAL_MONITOR, *LPPHYSICAL_MONITOR;

/// Contains a handle and text description corresponding to a physical monitor.
///
/// {@category Struct}
class PHYSICAL_MONITOR extends Struct {
  @IntPtr()
  external int hPhysicalMonitor;
  @Uint64()
  external int _data0;
  @Uint64()
  external int _data1;
  @Uint64()
  external int _data2;
  @Uint64()
  external int _data3;
  @Uint64()
  external int _data4;
  @Uint64()
  external int _data5;
  @Uint64()
  external int _data6;
  @Uint64()
  external int _data7;
  @Uint64()
  external int _data8;
  @Uint64()
  external int _data9;
  @Uint64()
  external int _data10;
  @Uint64()
  external int _data11;
  @Uint64()
  external int _data12;
  @Uint64()
  external int _data13;
  @Uint64()
  external int _data14;
  @Uint64()
  external int _data15;
}

extension PointerPHYSICAL_MONITORExtension on Pointer<PHYSICAL_MONITOR> {
  String get szPhysicalMonitorDescription => cast<IntPtr>()
      .elementAt(1)
      .cast<Utf16>()
      .unpackString(PHYSICAL_MONITOR_DESCRIPTION_SIZE);
}

// typedef struct tagCHOOSECOLORW {
//   DWORD        lStructSize;
//   HWND         hwndOwner;
//   HWND         hInstance;
//   COLORREF     rgbResult;
//   COLORREF     *lpCustColors;
//   DWORD        Flags;
//   LPARAM       lCustData;
//   LPCCHOOKPROC lpfnHook;
//   LPCWSTR      lpTemplateName;
// } CHOOSECOLORW, *LPCHOOSECOLORW;

/// Contains information the ChooseColor function uses to initialize the Color
/// dialog box. After the user closes the dialog box, the system returns
/// information about the user's selection in this structure.
///
/// {@category Struct}
class CHOOSECOLOR extends Struct {
  @Uint32()
  external int lStructSize;

  @IntPtr()
  external int hwndOwner;

  @IntPtr()
  external int hInstance;

  /// COLORREF is a DWORD that contains RGB values in the form 0x00bbggrr
  @Int32()
  external int rgbResult;

  /// COLORREF is a DWORD that contains RGB values in the form 0x00bbggrr
  external Pointer<Uint32> lpCustColors;

  @Uint32()
  external int Flags;

  @IntPtr()
  external int lCustData;

  external Pointer<IntPtr> lpfnHook;
  external Pointer<Uint16> lpTemplateName;

  factory CHOOSECOLOR.allocate() =>
      calloc<CHOOSECOLOR>().ref..lStructSize = sizeOf<CHOOSECOLOR>();
}

// typedef struct tagFINDREPLACEW {
//   DWORD        lStructSize;
//   HWND         hwndOwner;
//   HINSTANCE    hInstance;
//   DWORD        Flags;
//   LPWSTR       lpstrFindWhat;
//   LPWSTR       lpstrReplaceWith;
//   WORD         wFindWhatLen;
//   WORD         wReplaceWithLen;
//   LPARAM       lCustData;
//   LPFRHOOKPROC lpfnHook;
//   LPCWSTR      lpTemplateName;
// } FINDREPLACEW, *LPFINDREPLACEW;

/// Contains information that the FindText and ReplaceText functions use to
/// initialize the Find and Replace dialog boxes. The FINDMSGSTRING registered
/// message uses this structure to pass the user's search or replacement input
/// to the owner window of a Find or Replace dialog box.
///
/// {@category Struct}
class FINDREPLACE extends Struct {
  @Uint32()
  external int lStructSize;
  @IntPtr()
  external int hwndOwner;
  @IntPtr()
  external int hInstance;
  @Uint32()
  external int Flags;
  external Pointer<Utf16> lpstrFindWhat;
  external Pointer<Utf16> lpstrReplaceWith;
  @Uint16()
  external int wFindWhatLen;
  @Uint16()
  external int wReplaceWithLen;
  @IntPtr()
  external int lCustData;
  external Pointer<NativeFunction<LPFRHookProc>> lpfnHook;
  external Pointer<Utf16> lpTemplateName;
}

// typedef struct tagCHOOSEFONTW {
//   DWORD        lStructSize;
//   HWND         hwndOwner;
//   HDC          hDC;
//   LPLOGFONTW   lpLogFont;
//   INT          iPointSize;
//   DWORD        Flags;
//   COLORREF     rgbColors;
//   LPARAM       lCustData;
//   LPCFHOOKPROC lpfnHook;
//   LPCWSTR      lpTemplateName;
//   HINSTANCE    hInstance;
//   LPWSTR       lpszStyle;
//   WORD         nFontType;
//   WORD         ___MISSING_ALIGNMENT__;
//   INT          nSizeMin;
//   INT          nSizeMax;
// } CHOOSEFONTW;

/// Contains information that the ChooseFont function uses to initialize the
/// Font dialog box. After the user closes the dialog box, the system returns
/// information about the user's selection in this structure.
///
/// {@category Struct}
class CHOOSEFONT extends Struct {
  @Uint32()
  external int lStructSize;
  @IntPtr()
  external int hwndOwner;
  @IntPtr()
  external int hDC;

  external Pointer<LOGFONT> lpLogFont;

  @Int32()
  external int iPointSize;

  @Uint32()
  external int Flags;

  @Int32()
  external int rgbColors;
  @IntPtr()
  external int lCustData;

  external Pointer<NativeFunction> lpfnHook;
  external Pointer<Utf16> lpTemplateName;
  @IntPtr()
  external int hInstance;
  external Pointer<Utf16> lpszStyle;
  @Uint16()
  external int nFontType;
  @Uint16()
  external int reserved;
  @Int32()
  external int nSizeMin;
  @Int32()
  external int nSizeMax;
}

// typedef struct tagOFNW {
//    DWORD        lStructSize;
//    HWND         hwndOwner;
//    HINSTANCE    hInstance;
//    LPCWSTR      lpstrFilter;
//    LPWSTR       lpstrCustomFilter;
//    DWORD        nMaxCustFilter;
//    DWORD        nFilterIndex;
//    LPWSTR       lpstrFile;
//    DWORD        nMaxFile;
//    LPWSTR       lpstrFileTitle;
//    DWORD        nMaxFileTitle;
//    LPCWSTR      lpstrInitialDir;
//    LPCWSTR      lpstrTitle;
//    DWORD        Flags;
//    WORD         nFileOffset;
//    WORD         nFileExtension;
//    LPCWSTR      lpstrDefExt;
//    LPARAM       lCustData;
//    LPOFNHOOKPROC lpfnHook;
//    LPCWSTR      lpTemplateName;
//    void *        pvReserved;
//    DWORD        dwReserved;
//    DWORD        FlagsEx;
// } OPENFILENAMEW, *LPOPENFILENAMEW;

/// Contains information that the GetOpenFileName and GetSaveFileName functions
/// use to initialize an Open or Save As dialog box. After the user closes the
/// dialog box, the system returns information about the user's selection in
/// this structure.
///
/// {@category Struct}
class OPENFILENAME extends Struct {
  @Uint32()
  external int lStructSize;
  @IntPtr()
  external int hwndOwner;
  @IntPtr()
  external int hInstance;

  external Pointer<Utf16> lpstrFilter;
  external Pointer<Utf16> lpstrCustomFilter;

  @Uint32()
  external int nMaxCustFilter;
  @Uint32()
  external int nFilterIndex;

  external Pointer<Utf16> lpstrFile;
  @Uint32()
  external int nMaxFile;

  external Pointer<Utf16> lpstrFileTitle;
  @Uint32()
  external int nMaxFileTitle;

  external Pointer<Utf16> lpstrInitialDir;
  external Pointer<Utf16> lpstrTitle;

  @Uint32()
  external int Flags;
  @Uint16()
  external int nFileOffset;
  @Uint16()
  external int nFileExtension;

  external Pointer<Utf16> lpstrDefExt;

  @IntPtr()
  external int lCustData;

  external Pointer<NativeFunction> lpfnHook;
  external Pointer<Utf16> lpTemplateName;
  external Pointer<Void> pvReserved;

  @Uint32()
  external int dwReserved;
  @Uint32()
  external int FlagsEx;
}

// typedef struct {
//         lfHeight;
//         lfWidth;
//         lfEscapement;
//         lfOrientation;
//         lfWeight;
//   BYTE  lfItalic;
//   BYTE  lfUnderline;
//   BYTE  lfStrikeOut;
//   BYTE  lfCharSet;
//   BYTE  lfOutPrecision;
//   BYTE  lfClipPrecision;
//   BYTE  lfQuality;
//   BYTE  lfPitchAndFamily;
//   WCHAR lfFaceName[LF_FACESIZE];
// } LOGFONTW;

/// The LOGFONT structure defines the attributes of a font.
///
/// {@category Struct}
class LOGFONT extends Struct {
  @Int32()
  external int lfHeight;
  @Int32()
  external int lfWidth;
  @Int32()
  external int lfEscapement;
  @Int32()
  external int lfOrientation;
  @Int32()
  external int lfWeight;
  @Uint8()
  external int lfItalic;
  @Uint8()
  external int lfUnderline;
  @Uint8()
  external int lfStrikeOut;
  @Uint8()
  external int lfCharSet;
  @Uint8()
  external int lfOutPrecision;
  @Uint8()
  external int lfClipPrecision;
  @Uint8()
  external int lfQuality;
  @Uint8()
  external int lfPitchAndFamily;

  // Need to use @Int32() here, both because of the lack of fixed-size
  // arrays, and because @Int64() doesn't line up with word boundaries
  @Int32()
  external int lfFaceName1;
  @Int32()
  external int lfFaceName2;
  @Int32()
  external int lfFaceName3;
  @Int32()
  external int lfFaceName4;
  @Int32()
  external int lfFaceName5;
  @Int32()
  external int lfFaceName6;
  @Int32()
  external int lfFaceName7;
  @Int32()
  external int lfFaceName8;
  @Int32()
  external int lfFaceName9;
  @Int32()
  external int lfFaceName10;
  @Int32()
  external int lfFaceName11;
  @Int32()
  external int lfFaceName12;
  @Int32()
  external int lfFaceName13;
  @Int32()
  external int lfFaceName14;
  @Int32()
  external int lfFaceName15;
  @Int32()
  external int lfFaceName16;
}

extension PointerLOGFONTExtension on Pointer<LOGFONT> {
  Pointer<Utf16> get lfFaceName => cast<Uint8>().elementAt(28).cast<Utf16>();
}

// typedef struct tagENUMLOGFONTEXW {
//   LOGFONTW elfLogFont;
//   WCHAR    elfFullName[LF_FULLFACESIZE];
//   WCHAR    elfStyle[LF_FACESIZE];
//   WCHAR    elfScript[LF_FACESIZE];
// } ENUMLOGFONTEXW, *LPENUMLOGFONTEXW;

/// The ENUMLOGFONTEX structure contains information about an enumerated font.
///
/// {@category Struct}
class ENUMLOGFONTEX extends Struct {
  @Uint64()
  external int _data0;
  @Uint64()
  external int _data1;
  @Uint64()
  external int _data2;
  @Uint64()
  external int _data3;
  @Uint64()
  external int _data4;
  @Uint64()
  external int _data5;
  @Uint64()
  external int _data6;
  @Uint64()
  external int _data7;
  @Uint64()
  external int _data8;
  @Uint64()
  external int _data9;
  @Uint64()
  external int _data10;
  @Uint64()
  external int _data11;
  @Uint64()
  external int _data12;
  @Uint64()
  external int _data13;
  @Uint64()
  external int _data14;
  @Uint64()
  external int _data15;
  @Uint64()
  external int _data16;
  @Uint64()
  external int _data17;
  @Uint64()
  external int _data18;
  @Uint64()
  external int _data19;
  @Uint64()
  external int _data20;
  @Uint64()
  external int _data21;
  @Uint64()
  external int _data22;
  @Uint64()
  external int _data23;
  @Uint64()
  external int _data24;
  @Uint64()
  external int _data25;
  @Uint64()
  external int _data26;
  @Uint64()
  external int _data27;
  @Uint64()
  external int _data28;
  @Uint64()
  external int _data29;
  @Uint64()
  external int _data30;
  @Uint64()
  external int _data31;
  @Uint64()
  external int _data32;
  @Uint64()
  external int _data33;
  @Uint64()
  external int _data34;
  @Uint64()
  external int _data35;
  @Uint64()
  external int _data36;
  @Uint64()
  external int _data37;
  @Uint64()
  external int _data38;
  @Uint64()
  external int _data39;
  @Uint64()
  external int _data40;
  @Uint64()
  external int _data41;
  @Uint64()
  external int _data42;
  @Uint32()
  external int _data43;
}

extension PointerENUMLOGFONTEXExtension on Pointer<ENUMLOGFONTEX> {
  String get elfFullName => cast<Uint8>()
      .elementAt(sizeOf<LOGFONT>())
      .cast<Utf16>()
      .unpackString(LF_FULLFACESIZE);

  String get elfStyle => cast<Uint8>()
      .elementAt(sizeOf<LOGFONT>() + LF_FULLFACESIZE * 2)
      .cast<Utf16>()
      .unpackString(LF_FACESIZE);

  String get elfScript => cast<Uint8>()
      .elementAt(sizeOf<LOGFONT>() + ((LF_FULLFACESIZE + LF_FACESIZE) * 2))
      .cast<Utf16>()
      .unpackString(LF_FACESIZE);
}

// typedef struct tagCREATESTRUCTW {
//   LPVOID    lpCreateParams;
//   HINSTANCE hInstance;
//   HMENU     hMenu;
//   HWND      hwndParent;
//   int       cy;
//   int       cx;
//   int       y;
//   int       x;
//   LONG      style;
//   LPCWSTR   lpszName;
//   LPCWSTR   lpszClass;
//   DWORD     dwExStyle;
// } CREATESTRUCTW, *LPCREATESTRUCTW;

/// Defines the initialization parameters passed to the window procedure of an
/// application. These members are identical to the parameters of the
/// CreateWindowEx function.
///
/// {@category Struct}
class CREATESTRUCT extends Struct {
  external Pointer<Void> lpCreateParams;

  @IntPtr()
  external int hInstance;
  @IntPtr()
  external int hMenu;
  @IntPtr()
  external int hwndParent;
  @Int32()
  external int cy;
  @Int32()
  external int cx;
  @Int32()
  external int y;
  @Int32()
  external int x;
  @Int32()
  external int style;

  external Pointer<Utf16> lpszName;
  external Pointer<Utf16> lpszClass;

  @Uint32()
  external int dwExStyle;
}

// typedef struct tagMENUINFO {
//   DWORD     cbSize;
//   DWORD     fMask;
//   DWORD     dwStyle;
//   UINT      cyMax;
//   HBRUSH    hbrBack;
//   DWORD     dwContextHelpID;
//   ULONG_PTR dwMenuData;
// } MENUINFO, *LPMENUINFO;

/// Contains information about a menu.
///
/// {@category Struct}
class MENUINFO extends Struct {
  @Uint32()
  external int cbSize;
  @Uint32()
  external int fMask;
  @Uint32()
  external int dwStyle;
  @Uint32()
  external int cyMax;
  @IntPtr()
  external int hbrBack;
  @Uint32()
  external int dwContextHelpID;
  external Pointer<Uint32> dwMenuData;
}

// typedef struct tagMENUITEMINFOW {
//   UINT      cbSize;
//   UINT      fMask;
//   UINT      fType;
//   UINT      fState;
//   UINT      wID;
//   HMENU     hSubMenu;
//   HBITMAP   hbmpChecked;
//   HBITMAP   hbmpUnchecked;
//   ULONG_PTR dwItemData;
//   LPWSTR    dwTypeData;
//   UINT      cch;
//   HBITMAP   hbmpItem;
// } MENUITEMINFOW, *LPMENUITEMINFOW;

/// Contains information about a menu item.
///
/// {@category Struct}
class MENUITEMINFO extends Struct {
  @Uint32()
  external int cbSize;

  @Uint32()
  external int fMask;

  @Uint32()
  external int fType;

  @Uint32()
  external int fState;

  @Uint32()
  external int wID;

  @IntPtr()
  external int hSubMenu;

  @IntPtr()
  external int hbmpChecked;
  @IntPtr()
  external int hbmpUnchecked;

  external Pointer<Uint32> dwItemData;
  external Pointer<Utf16> dwTypeData;

  @Uint32()
  external int cch;

  @IntPtr()
  external int hbmpItem;
}

// typedef struct tagMSG {
//   HWND   hwnd;
//   UINT   message;
//   WPARAM wParam;
//   LPARAM lParam;
//   DWORD  time;
//   POINT  pt;
// } MSG, *PMSG, *NPMSG, *LPMSG;

/// Contains message information from a thread's message queue.
///
/// {@category Struct}
class MSG extends Struct {
  @IntPtr()
  external int hwnd;

  @Uint32()
  external int message;

  @IntPtr()
  external int wParam;

  @IntPtr()
  external int lParam;

  @Uint32()
  external int time;

  external POINT pt;
}

// typedef struct tagSIZE {
//   LONG cx;
//   LONG cy;
// } SIZE, *PSIZE;

/// The SIZE structure defines the width and height of a rectangle.
///
/// {@category Struct}
class SIZE extends Struct {
  @Int32()
  external int cx;

  @Int32()
  external int cy;
}

// typedef struct tagMINMAXINFO {
//   POINT ptReserved;
//   POINT ptMaxSize;
//   POINT ptMaxPosition;
//   POINT ptMinTrackSize;
//   POINT ptMaxTrackSize;
// } MINMAXINFO, *PMINMAXINFO, *LPMINMAXINFO;

/// Contains information about a window's maximized size and position and its
/// minimum and maximum tracking size.
///
/// {@category Struct}
class MINMAXINFO extends Struct {
  external POINT ptReserved;
  external POINT ptMaxSize;
  external POINT ptMaxPosition;
  external POINT ptMinTrackSize;
  external POINT ptMaxTrackSize;
}

// typedef struct tagPOINT {
//   LONG x;
//   LONG y;
// } POINT, *PPOINT, *NPPOINT, *LPPOINT;

/// The POINT structure defines the x- and y-coordinates of a point.
///
/// {@category Struct}
class POINT extends Struct {
  @Int32()
  external int x;

  @Int32()
  external int y;
}

// typedef struct tagPAINTSTRUCT {
//   HDC  hdc;
//   BOOL fErase;
//   RECT rcPaint;
//   BOOL fRestore;
//   BOOL fIncUpdate;
//   BYTE rgbReserved[32];
// } PAINTSTRUCT, *PPAINTSTRUCT, *NPPAINTSTRUCT, *LPPAINTSTRUCT;

/// The PAINTSTRUCT structure contains information for an application. This
/// information can be used to paint the client area of a window owned by that
/// application.
///
/// {@category Struct}
class PAINTSTRUCT extends Struct {
  @IntPtr()
  external int hdc;
  @Int32()
  external int fErase;

  external RECT rcPaint;

  @Int32()
  external int fRestore;
  @Int32()
  external int fIncUpdate;
  @Uint64()
  external int rgb1;
  @Uint64()
  external int rgb2;
  @Uint64()
  external int rgb3;
  @Uint64()
  external int rgb4;
}

// typedef struct tagRECT {
//   LONG left;
//   LONG top;
//   LONG right;
//   LONG bottom;
// } RECT, *PRECT, *NPRECT, *LPRECT;

/// The RECT structure defines a rectangle by the coordinates of its upper-left
/// and lower-right corners.
///
/// {@category Struct}
class RECT extends Struct {
  @Int32()
  external int left;
  @Int32()
  external int top;
  @Int32()
  external int right;
  @Int32()
  external int bottom;
}

// typedef struct tagINPUT {
//   DWORD type;
//   union {
//     MOUSEINPUT    mi;
//     KEYBDINPUT    ki;
//     HARDWAREINPUT hi;
//   } DUMMYUNIONNAME;
// } INPUT, *PINPUT, *LPINPUT;

/// Used by SendInput to store information for synthesizing input events such as
/// keystrokes, mouse movement, and mouse clicks.
///
/// {@category Struct}
class INPUT extends Struct {
  // 28 bytes on 32-bit, 40 bytes on 64-bit
  @Uint32()
  external int type;
  @Int32()
  external int _data0;
  @IntPtr()
  external int _data1;
  @IntPtr()
  external int _data2;
  @IntPtr()
  external int _data3;
  @Uint64()
  external int _data4;
}

extension PointerINPUTExtension on Pointer<INPUT> {
  // Location adjusts for padding on 32-bit or 64-bit
  MOUSEINPUT get mi =>
      MOUSEINPUT(cast<Uint8>().elementAt(sizeOf<IntPtr>()).cast());
  KEYBDINPUT get ki =>
      KEYBDINPUT(cast<Uint8>().elementAt(sizeOf<IntPtr>()).cast());
  HARDWAREINPUT get hi =>
      HARDWAREINPUT(cast<Uint8>().elementAt(sizeOf<IntPtr>()).cast());
}

// typedef struct tagMOUSEINPUT {
//   LONG      dx;
//   LONG      dy;
//   DWORD     mouseData;
//   DWORD     dwFlags;
//   DWORD     time;
//   ULONG_PTR dwExtraInfo;
// } MOUSEINPUT, *PMOUSEINPUT, *LPMOUSEINPUT;

/// Contains information about a simulated mouse event.
///
/// {@category Struct}
class MOUSEINPUT {
  Pointer<Uint32> ptr;

  MOUSEINPUT(this.ptr);

  int get dx => ptr.value;
  int get dy => ptr.elementAt(1).value;

  set dx(int value) => ptr.value = value;
  set dy(int value) => ptr.elementAt(1).value = value;

  int get mouseData => ptr.elementAt(2).value;
  int get dwFlags => ptr.elementAt(3).value;
  int get time => ptr.elementAt(4).value;
  int get dwExtraInfo => ptr.elementAt(5).value;

  set mouseData(int value) => ptr.elementAt(2).value = value;
  set dwFlags(int value) => ptr.elementAt(3).value = value;
  set time(int value) => ptr.elementAt(4).value = value;
  set dwExtraInfo(int value) => ptr.elementAt(5).value = value;
}

// typedef struct tagKEYBDINPUT {
//   WORD      wVk;
//   WORD      wScan;
//   DWORD     dwFlags;
//   DWORD     time;
//   ULONG_PTR dwExtraInfo;
// } KEYBDINPUT, *PKEYBDINPUT, *LPKEYBDINPUT;

/// Contains information about a simulated keyboard event.
///
/// {@category Struct}
class KEYBDINPUT {
  Pointer<Uint16> ptr;

  KEYBDINPUT(this.ptr);

  int get wVk => ptr.value;
  int get wScan => ptr.elementAt(1).value;
  int get dwFlags => ptr.elementAt(2).cast<Uint32>().value;
  int get time => ptr.elementAt(4).cast<Uint32>().value;
  int get dwExtraInfo => ptr.elementAt(6).cast<IntPtr>().value;

  set wVk(int value) => ptr.value = value;
  set wScan(int value) => ptr.elementAt(1).value = value;
  set dwFlags(int value) => ptr.elementAt(2).cast<Uint32>().value = value;
  set time(int value) => ptr.elementAt(4).cast<Uint32>().value = value;
  set dwExtraInfo(int value) => ptr.elementAt(6).cast<IntPtr>().value = value;
}

// typedef struct tagHARDWAREINPUT {
//   DWORD uMsg;
//   WORD  wParamL;
//   WORD  wParamH;
// } HARDWAREINPUT, *PHARDWAREINPUT, *LPHARDWAREINPUT;

/// Contains information about a simulated message generated by an input device
/// other than a keyboard or mouse.
///
/// {@category Struct}
class HARDWAREINPUT {
  Pointer<Uint16> ptr;

  HARDWAREINPUT(this.ptr);

  int get uMsg => ptr.cast<Uint32>().value;
  int get wParamL => ptr.elementAt(2).value;
  int get wParamH => ptr.elementAt(3).value;

  set uMsg(int value) => ptr.cast<Uint32>().value = value;
  set wParamL(int value) => ptr.elementAt(2).value = value;
  set wParamH(int value) => ptr.elementAt(3).value = value;
}

// typedef struct tagTEXTMETRICW {
//   LONG  tmHeight;
//   LONG  tmAscent;
//   LONG  tmDescent;
//   LONG  tmInternalLeading;
//   LONG  tmExternalLeading;
//   LONG  tmAveCharWidth;
//   LONG  tmMaxCharWidth;
//   LONG  tmWeight;
//   LONG  tmOverhang;
//   LONG  tmDigitizedAspectX;
//   LONG  tmDigitizedAspectY;
//   WCHAR tmFirstChar;
//   WCHAR tmLastChar;
//   WCHAR tmDefaultChar;
//   WCHAR tmBreakChar;
//   BYTE  tmItalic;
//   BYTE  tmUnderlined;
//   BYTE  tmStruckOut;
//   BYTE  tmPitchAndFamily;
//   BYTE  tmCharSet;
// } TEXTMETRICW, *PTEXTMETRICW, *NPTEXTMETRICW, *LPTEXTMETRICW;

/// The TEXTMETRIC structure contains basic information about a physical font.
/// All sizes are specified in logical units; that is, they depend on the
/// current mapping mode of the display context.
///
/// {@category Struct}
class TEXTMETRIC extends Struct {
  @Int32()
  external int tmHeight;
  @Int32()
  external int tmAscent;
  @Int32()
  external int tmDescent;
  @Int32()
  external int tmInternalLeading;
  @Int32()
  external int tmExternalLeading;
  @Int32()
  external int tmAveCharWidth;
  @Int32()
  external int tmMaxCharWidth;
  @Int32()
  external int tmWeight;
  @Int32()
  external int tmOverhang;
  @Int32()
  external int tmDigitizedAspectX;
  @Int32()
  external int tmDigitizedAspectY;
  @Int16()
  external int tmFirstChar;
  @Int16()
  external int tmLastChar;
  @Int16()
  external int tmDefaultChar;
  @Int16()
  external int tmBreakChar;
  @Uint8()
  external int tmItalic;
  @Uint8()
  external int tmUnderlined;
  @Uint8()
  external int tmStruckOut;
  @Uint8()
  external int tmPitchAndFamily;
  @Uint8()
  external int tmCharSet;
}

// typedef struct tagSCROLLINFO {
//   UINT cbSize;
//   UINT fMask;
//   int  nMin;
//   int  nMax;
//   UINT nPage;
//   int  nPos;
//   int  nTrackPos;
// } SCROLLINFO, *LPSCROLLINFO;

/// The SCROLLINFO structure contains scroll bar parameters to be set by the
/// SetScrollInfo function (or SBM_SETSCROLLINFO message), or retrieved by the
/// GetScrollInfo function (or SBM_GETSCROLLINFO message).
///
/// {@category Struct}
class SCROLLINFO extends Struct {
  @Uint32()
  external int cbSize;
  @Uint32()
  external int fMask;
  @Int32()
  external int nMin;
  @Int32()
  external int nMax;
  @Uint32()
  external int nPage;
  @Int32()
  external int nPos;
  @Int32()
  external int nTrackPos;
}

// typedef struct _SHELLEXECUTEINFOW {
//   DWORD     cbSize;
//   ULONG     fMask;
//   HWND      hwnd;
//   LPCWSTR   lpVerb;
//   LPCWSTR   lpFile;
//   LPCWSTR   lpParameters;
//   LPCWSTR   lpDirectory;
//   int       nShow;
//   HINSTANCE hInstApp;
//   void      *lpIDList;
//   LPCWSTR   lpClass;
//   HKEY      hkeyClass;
//   DWORD     dwHotKey;
//   union {
//     HANDLE hIcon;
//     HANDLE hMonitor;
//   } DUMMYUNIONNAME;
//   HANDLE    hProcess;
// } SHELLEXECUTEINFOW, *LPSHELLEXECUTEINFOW;

/// Contains information used by ShellExecuteEx.
///
/// {@category Struct}
class SHELLEXECUTEINFO extends Struct {
  @Uint32()
  external int cbSize;
  @Uint32()
  external int fMask;
  @IntPtr()
  external int hwnd;

  external Pointer<Utf16> lpVerb;
  external Pointer<Utf16> lpFile;
  external Pointer<Utf16> lpParameters;
  external Pointer<Utf16> lpDirectory;

  @Int32()
  external int nShow;
  @IntPtr()
  external int hInstApp;
  external Pointer lpIDList;
  external Pointer<Utf16> lpClass;
  @IntPtr()
  external int hkeyClass;
  @Uint32()
  external int dwHotKey;
  @IntPtr()
  external int hMonitor;
  @IntPtr()
  external int hProcess;

  factory SHELLEXECUTEINFO.allocate() =>
      calloc<SHELLEXECUTEINFO>().ref..cbSize = sizeOf<SHELLEXECUTEINFO>();
}

// typedef struct _SHQUERYRBINFO {
//     DWORD   cbSize;
//     __int64 i64Size;
//     __int64 i64NumItems;
// #endif
// } SHQUERYRBINFO, *LPSHQUERYRBINFO;

/// Contains the size and item count information retrieved by the
/// SHQueryRecycleBin function.
///
/// {@category Struct}
class SHQUERYRBINFO extends Struct {
  @Int32()
  external int cbSize;
  @Int64()
  external int i64Size;
  @Int64()
  external int i64NumItems;

  factory SHQUERYRBINFO.allocate() =>
      calloc<SHQUERYRBINFO>().ref..cbSize = sizeOf<SHQUERYRBINFO>();
}

// *** COM STRUCTS ***

// typedef struct _GUID {
//     unsigned long  Data1;
//     unsigned short Data2;
//     unsigned short Data3;
//     unsigned char  Data4[ 8 ];
// } GUID;

/// Represents a globally unique identifier (GUID).
///
/// {@category Struct}
class GUID extends Struct {
  @Uint32()
  external int Data1;
  @Uint16()
  external int Data2;
  @Uint16()
  external int Data3;
  @Uint64()
  external int Data4;

  /// Print GUID in common {FDD39AD0-238F-46AF-ADB4-6C85480369C7} format
  @override
  String toString() {
    final comp1 = (Data4 & 0xFF).toRadixString(16).padLeft(2, '0') +
        ((Data4 & 0xFF00) >> 8).toRadixString(16).padLeft(2, '0');

    // This is hacky as all get-out :)
    final comp2 = ((Data4 & 0xFF0000) >> 16).toRadixString(16).padLeft(2, '0') +
        ((Data4 & 0xFF000000) >> 24).toRadixString(16).padLeft(2, '0') +
        ((Data4 & 0xFF00000000) >> 32).toRadixString(16).padLeft(2, '0') +
        ((Data4 & 0xFF0000000000) >> 40).toRadixString(16).padLeft(2, '0') +
        ((Data4 & 0xFF000000000000) >> 48).toRadixString(16).padLeft(2, '0') +
        (BigInt.from(Data4 & 0xFF00000000000000).toUnsigned(64) >> 56)
            .toRadixString(16)
            .padLeft(2, '0');

    return '{${Data1.toRadixString(16).padLeft(8, '0').toUpperCase()}-'
        '${Data2.toRadixString(16).padLeft(4, '0').toUpperCase()}-'
        '${Data3.toRadixString(16).padLeft(4, '0').toUpperCase()}-'
        '${comp1.toUpperCase()}-'
        '${comp2.toUpperCase()}}';
  }
}

extension PointerGUIDExtension on Pointer<GUID> {
  /// Create GUID from common {FDD39AD0-238F-46AF-ADB4-6C85480369C7} format
  void setGUID(String guidString) {
    assert(guidString.length == 38);
    ref.Data1 = int.parse(guidString.substring(1, 9), radix: 16);
    ref.Data2 = int.parse(guidString.substring(10, 14), radix: 16);
    ref.Data3 = int.parse(guidString.substring(15, 19), radix: 16);

    // Final component is pushed on the stack in reverse order per x64
    // calling convention.
    final rawString = guidString.substring(35, 37) +
        guidString.substring(33, 35) +
        guidString.substring(31, 33) +
        guidString.substring(29, 31) +
        guidString.substring(27, 29) +
        guidString.substring(25, 27) +
        guidString.substring(22, 24) +
        guidString.substring(20, 22);

    // We need to split this to avoid overflowing a signed int.parse()
    ref.Data4 = (int.parse(rawString.substring(0, 4), radix: 16) << 48) +
        int.parse(rawString.substring(4, 16), radix: 16);
  }
}

// typedef struct _CREDENTIAL_ATTRIBUTEW {
//     LPWSTR  Keyword;
//     DWORD   Flags;
//     DWORD   ValueSize;
//     LPBYTE  Value;
// } CREDENTIAL_ATTRIBUTEW, *PCREDENTIAL_ATTRIBUTEW;

/// The CREDENTIAL_ATTRIBUTE structure contains an application-defined attribute
/// of the credential. An attribute is a keyword-value pair. It is up to the
/// application to define the meaning of the attribute.
///
/// {@category Struct}
class CREDENTIAL_ATTRIBUTE extends Struct {
  external Pointer<Utf16> Keyword;

  @Uint32()
  external int Flags;

  @Uint32()
  external int ValueSize;

  external Pointer<Uint8> Value;
}

// typedef struct _CREDENTIALW {
//     DWORD Flags;
//     DWORD Type;
//     LPWSTR TargetName;
//     LPWSTR Comment;
//     FILETIME LastWritten;
//     DWORD CredentialBlobSize;
//     LPBYTE CredentialBlob;
//     DWORD Persist;
//     DWORD AttributeCount;
//     PCREDENTIAL_ATTRIBUTEW Attributes;
//     LPWSTR TargetAlias;
//     LPWSTR UserName;
// } CREDENTIALW, *PCREDENTIALW;

/// The CREDENTIAL structure contains an individual credential.
///
/// {@category Struct}
class CREDENTIAL extends Struct {
  @Uint32()
  external int Flags;
  @Uint32()
  external int Type;

  external Pointer<Utf16> TargetName;
  external Pointer<Utf16> Comment;
  external Pointer<FILETIME> LastWritten;

  @Uint32()
  external int CredentialBlobSize;

  external Pointer<Uint8> CredentialBlob;

  @Uint32()
  external int Persist;

  @Uint32()
  external int AttributeCount;

  external Pointer<CREDENTIAL_ATTRIBUTE> Attributes;
  external Pointer<Utf16> TargetAlias;
  external Pointer<Utf16> UserName;
}

// *** CONSOLE STRUCTS ***

// Dart FFI does not yet have support for nested structs, so there's extra
// work necessary to unpack parameters like COORD and SMALL_RECT. The Dart
// issue for this work is https://github.com/dart-lang/sdk/issues/37271.

// typedef struct tagBITMAPINFO {
//   BITMAPINFOHEADER bmiHeader;
//   RGBQUAD          bmiColors[1];
// } BITMAPINFO, *LPBITMAPINFO, *PBITMAPINFO;
//
// typedef struct tagBITMAPINFOHEADER {
//   DWORD biSize;
//   LONG  biWidth;
//   LONG  biHeight;
//   WORD  biPlanes;
//   WORD  biBitCount;
//   DWORD biCompression;
//   DWORD biSizeImage;
//   LONG  biXPelsPerMeter;
//   LONG  biYPelsPerMeter;
//   DWORD biClrUsed;
//   DWORD biClrImportant;
// } BITMAPINFOHEADER, *PBITMAPINFOHEADER;
//
// typedef struct tagRGBQUAD {
//   BYTE rgbBlue;
//   BYTE rgbGreen;
//   BYTE rgbRed;
//   BYTE rgbReserved;
// } RGBQUAD;

/// The BITMAPINFO structure defines the dimensions and color information for a
/// device-independent bitmap (DIB).
///
/// {@category Struct}
class BITMAPINFO extends Struct {
  @Uint32()
  external int biSize;
  @Int32()
  external int biWidth;
  @Int32()
  external int biHeight;
  @Uint16()
  external int biPlanes;
  @Uint16()
  external int biBitCount;
  @Uint32()
  external int biCompression;
  @Uint32()
  external int biSizeImage;
  @Int32()
  external int biXPelsPerMeter;
  @Int32()
  external int biYPelsPerMeter;
  @Uint32()
  external int biClrUsed;
  @Uint32()
  external int biClrImportant;
  @Uint8()
  external int rgbBlue;
  @Uint8()
  external int rgbGreen;
  @Uint8()
  external int rgbRed;
  @Uint8()
  external int rgbReserved;

  factory BITMAPINFO.allocate() => calloc<BITMAPINFO>().ref..biSize = 44;
}

// typedef struct tagBITMAP {
//   LONG   bmType;
//   LONG   bmWidth;
//   LONG   bmHeight;
//   LONG   bmWidthBytes;
//   WORD   bmPlanes;
//   WORD   bmBitsPixel;
//   LPVOID bmBits;
// } BITMAP, *PBITMAP, *NPBITMAP, *LPBITMAP;

/// The BITMAP structure defines the type, width, height, color format, and bit
/// values of a bitmap.
///
/// {@category Struct}
class BITMAP extends Struct {
  @Int32()
  external int bmType;
  @Int32()
  external int bmWidth;
  @Int32()
  external int bmHeight;
  @Int32()
  external int bmWidthBytes;
  @Int16()
  external int bmPlanes;
  @Int16()
  external int bmBitsPixel;
  external Pointer bmBits;
}

// typedef struct tagBITMAPFILEHEADER {
//   WORD  bfType;
//   DWORD bfSize;
//   WORD  bfReserved1;
//   WORD  bfReserved2;
//   DWORD bfOffBits;
// } BITMAPFILEHEADER, *LPBITMAPFILEHEADER, *PBITMAPFILEHEADER;

/// The BITMAPFILEHEADER structure contains information about the type, size,
/// and layout of a file that contains a DIB.
///
/// {@category Struct}
class BITMAPFILEHEADER extends Struct {
  @Uint16()
  external int bfType;
  @Uint32()
  external int bfSize;
  @Uint16()
  external int bfReserved1;
  @Uint16()
  external int bfReserved2;
  @Uint32()
  external int bfOffBits;
}

// typedef struct tagBITMAPINFOHEADER {
//   DWORD biSize;
//   LONG  biWidth;
//   LONG  biHeight;
//   WORD  biPlanes;
//   WORD  biBitCount;
//   DWORD biCompression;
//   DWORD biSizeImage;
//   LONG  biXPelsPerMeter;
//   LONG  biYPelsPerMeter;
//   DWORD biClrUsed;
//   DWORD biClrImportant;
// } BITMAPINFOHEADER, *LPBITMAPINFOHEADER, *PBITMAPINFOHEADER;

/// The BITMAPINFOHEADER structure contains information about the dimensions and
/// color format of a device-independent bitmap (DIB).
///
/// {@category Struct}
class BITMAPINFOHEADER extends Struct {
  @Uint32()
  external int biSize;
  @Int32()
  external int biWidth;
  @Int32()
  external int biHeight;
  @Uint16()
  external int biPlanes;
  @Uint16()
  external int biBitCount;
  @Uint32()
  external int biCompression;
  @Uint32()
  external int biSizeImage;
  @Int32()
  external int biXPelsPerMeter;
  @Int32()
  external int biYPelsPerMeter;
  @Uint32()
  external int biClrUsed;
  @Uint32()
  external int biClrImportant;

  factory BITMAPINFOHEADER.allocate() =>
      calloc<BITMAPINFOHEADER>().ref..biSize = sizeOf<BITMAPINFOHEADER>();
}

// typedef struct tagPALETTEENTRY {
//   BYTE peRed;
//   BYTE peGreen;
//   BYTE peBlue;
//   BYTE peFlags;
// } PALETTEENTRY;

/// The PALETTEENTRY structure specifies the color and usage of an entry in a
/// logical palette. A logical palette is defined by a LOGPALETTE structure.
///
/// {@category Struct}
class PALETTEENTRY extends Struct {
  @Uint8()
  external int peRed;
  @Uint8()
  external int peGreen;
  @Uint8()
  external int peBlue;
  @Uint8()
  external int peFlags;
}

// typedef struct tagDRAWTEXTPARAMS {
//   UINT cbSize;
//   int  iTabLength;
//   int  iLeftMargin;
//   int  iRightMargin;
//   UINT uiLengthDrawn;
// } DRAWTEXTPARAMS, *LPDRAWTEXTPARAMS;

/// The DRAWTEXTPARAMS structure contains extended formatting options for the
/// DrawTextEx function.
///
/// {@category Struct}
class DRAWTEXTPARAMS extends Struct {
  @Uint32()
  external int cbSize;
  @Int32()
  external int iTabLength;
  @Int32()
  external int iLeftMargin;
  @Int32()
  external int iRightMargin;
  @Uint32()
  external int uiLengthDrawn;
}

// typedef struct _FILETIME {
//     DWORD dwLowDateTime;
//     DWORD dwHighDateTime;
// } FILETIME, *PFILETIME, *LPFILETIME;

/// Contains a 64-bit value representing the number of 100-nanosecond intervals
/// since January 1, 1601 (UTC).
///
/// {@category Struct}
class FILETIME extends Struct {
  @Uint32()
  external int dwLowDateTime;
  @Uint32()
  external int dwHighDateTime;
}

// typedef struct KNOWNFOLDER_DEFINITION
//     {
//     KF_CATEGORY category;
//     LPWSTR pszName;
//     LPWSTR pszDescription;
//     KNOWNFOLDERID fidParent;
//     LPWSTR pszRelativePath;
//     LPWSTR pszParsingName;
//     LPWSTR pszTooltip;
//     LPWSTR pszLocalizedName;
//     LPWSTR pszIcon;
//     LPWSTR pszSecurity;
//     DWORD dwAttributes;
//     KF_DEFINITION_FLAGS kfdFlags;
//     FOLDERTYPEID ftidType;
//     } 	KNOWNFOLDER_DEFINITION;

/// Defines the specifics of a known folder.
///
/// {@category Struct}
class KNOWNFOLDER_DEFINITION extends Struct {
  @Int32()
  external int category;
  external Pointer<Utf16> pszName;
  external Pointer<Utf16> pszDescription;

  @Uint32()
  external int fidParent_guid1;
  @Uint16()
  external int fidParent_guid2;
  @Uint16()
  external int fidParent_guid3;
  @Uint64()
  external int fidParent_guid4;

  external Pointer<Utf16> pszRelativePath;
  external Pointer<Utf16> pszParsingName;
  external Pointer<Utf16> pszTooltip;
  external Pointer<Utf16> pszLocalizedName;
  external Pointer<Utf16> pszIcon;
  external Pointer<Utf16> pszSecurity;

  @Uint32()
  external int dwAttributes;
  @Uint32()
  external int kfdFlags;

  @Uint32()
  external int ftidType_guid1;
  @Uint16()
  external int ftidType_guid2;
  @Uint16()
  external int ftidType_guid3;
  @Uint64()
  external int ftidType_guid4;
}

// typedef struct _SHITEMID
//     {
//     USHORT cb;
//     BYTE abID[ 1 ];
//     }

/// Defines an item identifier.
///
/// {@category Struct}
class SHITEMID extends Struct {
  @Uint16()
  external int cb;
  @Uint8()
  external int abID;
}

// typedef struct tagDISPPARAMS {
//   VARIANTARG *rgvarg;
//   DISPID     *rgdispidNamedArgs;
//   UINT       cArgs;
//   UINT       cNamedArgs;
// } DISPPARAMS;

/// Contains the arguments passed to a method or property.
///
/// {@category Struct}
class DISPPARAMS extends Struct {
  external Pointer rgvarg;
  external Pointer<Int32> rgdispidNamedArgs;

  @Int16()
  external int cArgs;

  @Int16()
  external int cNamedArgs;
}

// *** CONSOLE STRUCTS ***

// typedef struct _CONSOLE_CURSOR_INFO {
//   DWORD dwSize;
//   BOOL  bVisible;
// } CONSOLE_CURSOR_INFO, *PCONSOLE_CURSOR_INFO;

/// Contains information about the console cursor.
///
/// {@category Struct}
class CONSOLE_CURSOR_INFO extends Struct {
  @Uint32()
  external int dwSize;
  @Int32()
  external int bVisible;
}

// typedef struct _CONSOLE_SCREEN_BUFFER_INFO {
//   COORD      dwSize;
//   COORD      dwCursorPosition;
//   WORD       wAttributes;
//   SMALL_RECT srWindow;
//   COORD      dwMaximumWindowSize;
// } CONSOLE_SCREEN_BUFFER_INFO;

/// Contains information about a console screen buffer.
///
/// {@category Struct}
class CONSOLE_SCREEN_BUFFER_INFO extends Struct {
  external COORD dwSize;
  external COORD dwCursorPosition;
  @Uint16()
  external int wAttributes;
  external SMALL_RECT srWindow;
  external COORD dwMaximumWindowSize;
}

// typedef struct _CONSOLE_SELECTION_INFO {
//   DWORD      dwFlags;
//   COORD      dwSelectionAnchor;
//   SMALL_RECT srSelection;
// } CONSOLE_SELECTION_INFO, *PCONSOLE_SELECTION_INFO;

/// Contains information for a console selection.
///
/// {@category Struct}
class CONSOLE_SELECTION_INFO extends Struct {
  @Uint32()
  external int dwFlags;

  external COORD dwSelectionAnchor;
  external SMALL_RECT srSelection;
}

// typedef struct _COORD {
//   SHORT X;
//   SHORT Y;
// } COORD, *PCOORD;

/// Defines the coordinates of a character cell in a console screen buffer. The
/// origin of the coordinate system (0,0) is at the top, left cell of the
/// buffer.
///
/// {@category Struct}
class COORD extends Struct {
  @Int16()
  external int X;

  @Int16()
  external int Y;
}

// typedef struct _CHAR_INFO {
//   union {
//     WCHAR UnicodeChar;
//     CHAR  AsciiChar;
//   } Char;
//   WORD  Attributes;
// } CHAR_INFO, *PCHAR_INFO;

/// Specifies a Unicode or ANSI character and its attributes. This structure is
/// used by console functions to read from and write to a console screen buffer.
///
/// {@category Struct}
class CHAR_INFO extends Struct {
  @Int16()
  external int UnicodeChar;

  @Int16()
  external int Attributes;
}

// typedef struct _SMALL_RECT {
//   SHORT Left;
//   SHORT Top;
//   SHORT Right;
//   SHORT Bottom;
// } SMALL_RECT;

/// Defines the coordinates of the upper left and lower right corners of a
/// rectangle.
///
/// {@category Struct}
class SMALL_RECT extends Struct {
  @Int16()
  external int Left;

  @Int16()
  external int Top;

  @Int16()
  external int Right;

  @Int16()
  external int Bottom;
}
// typedef struct tagINITCOMMONCONTROLSEX {
//   DWORD dwSize;
//   DWORD dwICC;
// } INITCOMMONCONTROLSEX, *LPINITCOMMONCONTROLSEX;

/// Carries information used to load common control classes from the
/// dynamic-link library (DLL). This structure is used with the
/// InitCommonControlsEx function.
///
/// {@category Struct}
class INITCOMMONCONTROLSEX extends Struct {
  @Uint32()
  external int dwSize;
  @Uint32()
  external int dwICC;

  factory INITCOMMONCONTROLSEX.allocate() => calloc<INITCOMMONCONTROLSEX>().ref
    ..dwSize = sizeOf<INITCOMMONCONTROLSEX>();
}

class DLGTEMPLATE extends Struct {
  @Uint32()
  external int style;
  @Uint32()
  external int dwExtendedStyle;
  @Uint16()
  external int cdit;
  @Uint16()
  external int x;
  @Uint16()
  external int y;
  @Uint16()
  external int cx;
  @Uint16()
  external int cy;
}

class DLGITEMTEMPLATE extends Struct {
  @Uint32()
  external int style;

  @Uint32()
  external int dwExtendedStyle;

  @Int16()
  external int x;

  @Int16()
  external int y;

  @Int16()
  external int cx;

  @Int16()
  external int cy;

  @Uint16()
  external int id;

  // sizeOf returns 20, because Dart over-allocates to DWORD boundaries. Instead
  // we allocate the *actual* size of this.
  factory DLGITEMTEMPLATE.allocate() =>
      calloc<Uint8>(count: 18).cast<DLGITEMTEMPLATE>().ref;
}

// typedef struct _TASKDIALOGCONFIG {
//   UINT                           cbSize;
//   HWND                           hwndParent;
//   HINSTANCE                      hInstance;
//   TASKDIALOG_FLAGS               dwFlags;
//   TASKDIALOG_COMMON_BUTTON_FLAGS dwCommonButtons;
//   PCWSTR                         pszWindowTitle;
//   union {
//     HICON  hMainIcon;
//     PCWSTR pszMainIcon;
//   } DUMMYUNIONNAME;
//   PCWSTR                         pszMainInstruction;

//   PCWSTR                         pszContent;
//   UINT                           cButtons;
//   const TASKDIALOG_BUTTON        *pButtons;
//   int                            nDefaultButton;
//   UINT                           cRadioButtons;
//   const TASKDIALOG_BUTTON        *pRadioButtons;
//   int                            nDefaultRadioButton;
//   PCWSTR                         pszVerificationText;
//   PCWSTR                         pszExpandedInformation;
//   PCWSTR                         pszExpandedControlText;
//   PCWSTR                         pszCollapsedControlText;
//   union {
//     HICON  hFooterIcon;
//     PCWSTR pszFooterIcon;
//   } DUMMYUNIONNAME2;
//   PCWSTR                         pszFooter;
//   PFTASKDIALOGCALLBACK           pfCallback;
//   LONG_PTR                       lpCallbackData;
//   UINT                           cxWidth;
// } TASKDIALOGCONFIG;

// TODO: This struct is packed (#include <pshpack1.h> before the struct
// declaration in CommCtrl.h. Unfortunately Dart FFI does not yet support packed
// structs (https://github.com/dart-lang/sdk/issues/38158), so this cannot yet
// be used.

/// The TASKDIALOGCONFIG structure contains information used to display a task
/// dialog. The TaskDialogIndirect function uses this structure.
///
/// {@category Struct}
class TASKDIALOGCONFIG extends Struct {
  @Uint32()
  external int cbSize;
  @IntPtr()
  external int hwndParent;
  @IntPtr()
  external int hInstance;
  @Uint32()
  external int dwFlags;
  @Uint32()
  external int dwCommonButtons;
  external Pointer<Utf16> pszWindowTitle;
  @IntPtr()
  external int hMainIcon;

  external Pointer<Utf16> pszMainInstruction;
  external Pointer<Utf16> pszContent;

  @Uint32()
  external int cButtons;

  external Pointer<TASKDIALOG_BUTTON> pButtons;

  @Int32()
  external int nDefaultButton;
  @Uint32()
  external int cRadioButtons;

  external Pointer<TASKDIALOG_BUTTON> pRadioButtons;

  @Int32()
  external int nDefaultRadioButton;

  external Pointer<Utf16> pszVerificationText;
  external Pointer<Utf16> pszExpandedInformation;
  external Pointer<Utf16> pszExpandedControlText;
  external Pointer<Utf16> pszCollapsedControlText;

  @IntPtr()
  external int hFooterIcon;

  external Pointer<Utf16> pszFooter;
  external Pointer<NativeFunction> pfCallback;

  @IntPtr()
  external int lpCallbackData;
  @Uint32()
  external int cxWidth;

  factory TASKDIALOGCONFIG.allocate() =>
      calloc<TASKDIALOGCONFIG>().ref..cbSize = sizeOf<TASKDIALOGCONFIG>();
}

// typedef struct _TASKDIALOG_BUTTON
// {
//     int     nButtonID;
//     PCWSTR  pszButtonText;
// } TASKDIALOG_BUTTON;

/// The TASKDIALOG_BUTTON structure contains information used to display a
/// button in a task dialog. The TASKDIALOGCONFIG structure uses this structure.
///
/// {@category Struct}
class TASKDIALOG_BUTTON extends Struct {
  @Int32()
  external int nButtonID;

  external Pointer<Utf16> pszButtonText;
}

// typedef struct _DLLVERSIONINFO
// {
//     DWORD cbSize;
//     DWORD dwMajorVersion;                   // Major version
//     DWORD dwMinorVersion;                   // Minor version
//     DWORD dwBuildNumber;                    // Build number
//     DWORD dwPlatformID;                     // DLLVER_PLATFORM_*
// } DLLVERSIONINFO;

/// Receives DLL-specific version information. It is used with the DllGetVersion
/// function.
///
/// {@category Struct}
class DLLVERSIONINFO extends Struct {
  @Uint32()
  external int cbSize;
  @Uint32()
  external int dwMajorVersion;
  @Uint32()
  external int dwMinorVersion;
  @Uint32()
  external int dwBuildNumber;
  @Uint32()
  external int dwPlatformID;

  factory DLLVERSIONINFO.allocate() =>
      calloc<DLLVERSIONINFO>().ref..cbSize = sizeOf<DLLVERSIONINFO>();
}

// typedef struct _OSVERSIONINFOW {
//   DWORD dwOSVersionInfoSize;
//   DWORD dwMajorVersion;
//   DWORD dwMinorVersion;
//   DWORD dwBuildNumber;
//   DWORD dwPlatformId;
//   WCHAR szCSDVersion[128];
// } OSVERSIONINFOW, *POSVERSIONINFOW, *LPOSVERSIONINFOW, RTL_OSVERSIONINFOW, *PRTL_OSVERSIONINFOW;

const _OSVERSIONINFO_STRUCT_SIZE = 20 + (128 * 2);

/// Contains operating system version information. The information includes
/// major and minor version numbers, a build number, a platform identifier, and
/// descriptive text about the operating system. This structure is used with the
/// GetVersionEx function.
///
/// {@category Struct}
class OSVERSIONINFO extends Struct {
  @Uint32()
  external int dwOSVersionInfoSize;
  @Uint32()
  external int dwMajorVersion;
  @Uint32()
  external int dwMinorVersion;
  @Uint32()
  external int dwBuildNumber;
  @Uint32()
  external int dwPlatformId;

  // These fields are never used directly, but ensure that sizeOf returns at
  // least the right size, so heap allocations are sufficient.
  @Uint64()
  external int _data0;
  @Uint64()
  external int _data1;
  @Uint64()
  external int _data2;
  @Uint64()
  external int _data3;
  @Uint64()
  external int _data4;
  @Uint64()
  external int _data5;
  @Uint64()
  external int _data6;
  @Uint64()
  external int _data7;
  @Uint64()
  external int _data8;
  @Uint64()
  external int _data9;
  @Uint64()
  external int _data10;
  @Uint64()
  external int _data11;
  @Uint64()
  external int _data12;
  @Uint64()
  external int _data13;
  @Uint64()
  external int _data14;
  @Uint64()
  external int _data15;
  @Uint64()
  external int _data16;
  @Uint64()
  external int _data17;
  @Uint64()
  external int _data18;
  @Uint64()
  external int _data19;
  @Uint64()
  external int _data20;
  @Uint64()
  external int _data21;
  @Uint64()
  external int _data22;
  @Uint64()
  external int _data23;
  @Uint64()
  external int _data24;
  @Uint64()
  external int _data25;
  @Uint64()
  external int _data26;
  @Uint64()
  external int _data27;
  @Uint64()
  external int _data28;
  @Uint64()
  external int _data29;
  @Uint64()
  external int _data30;

  factory OSVERSIONINFO.allocate() =>
      calloc<Uint8>(count: _OSVERSIONINFO_STRUCT_SIZE).cast<OSVERSIONINFO>().ref
        ..dwOSVersionInfoSize = _OSVERSIONINFO_STRUCT_SIZE;
}

extension PointerOSVERSIONINFOExtension on Pointer<OSVERSIONINFO> {
  String get szCSDVersion =>
      cast<Uint8>().elementAt(20).cast<Utf16>().unpackString(128);
}

// typedef struct _SYSTEMTIME {
//   WORD wYear;
//   WORD wMonth;
//   WORD wDayOfWeek;
//   WORD wDay;
//   WORD wHour;
//   WORD wMinute;
//   WORD wSecond;
//   WORD wMilliseconds;
// } SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

/// Specifies a date and time, using individual members for the month, day,
/// year, weekday, hour, minute, second, and millisecond. The time is either in
/// coordinated universal time (UTC) or local time, depending on the function
/// that is being called.
///
/// {@category Struct}
class SYSTEMTIME extends Struct {
  @Uint16()
  external int wYear;
  @Uint16()
  external int wMonth;
  @Uint16()
  external int wDayOfWeek;
  @Uint16()
  external int wDay;
  @Uint16()
  external int wHour;
  @Uint16()
  external int wMinute;
  @Uint16()
  external int wSecond;
  @Uint16()
  external int wMilliseconds;
}

// typedef struct _BLUETOOTH_AUTHENTICATION_CALLBACK_PARAMS {
//   BLUETOOTH_DEVICE_INFO                 deviceInfo;
//   BLUETOOTH_AUTHENTICATION_METHOD       authenticationMethod;
//   BLUETOOTH_IO_CAPABILITY               ioCapability;
//   BLUETOOTH_AUTHENTICATION_REQUIREMENTS authenticationRequirements;
//   union {
//     ULONG Numeric_Value;
//     ULONG Passkey;
//   };
// } BLUETOOTH_AUTHENTICATION_CALLBACK_PARAMS, *PBLUETOOTH_AUTHENTICATION_CALLBACK_PARAMS;

/// The BLUETOOTH_AUTHENTICATION_CALLBACK_PARAMS structure contains specific
/// configuration information about the Bluetooth device responding to an
/// authentication request.
///
/// /// {@category Struct}
class BLUETOOTH_AUTHENTICATION_CALLBACK_PARAMS extends Struct {
  external BLUETOOTH_DEVICE_INFO deviceInfo;
  @Uint32()
  external int authenticationMethod;
  @Uint32()
  external int ioCapability;
  @Uint32()
  external int authenticationRequirements;
  @Uint32()
  external int Numeric_Value;

  int get Passkey => Numeric_Value;
  set Passkey(int value) => Numeric_Value = value;
}

// typedef struct _BLUETOOTH_DEVICE_INFO {
//   DWORD             dwSize;
//   BLUETOOTH_ADDRESS Address;
//   ULONG             ulClassofDevice;
//   BOOL              fConnected;
//   BOOL              fRemembered;
//   BOOL              fAuthenticated;
//   SYSTEMTIME        stLastSeen;
//   SYSTEMTIME        stLastUsed;
//   WCHAR             szName[BLUETOOTH_MAX_NAME_SIZE];
// } BLUETOOTH_DEVICE_INFO_STRUCT;

/// The BLUETOOTH_DEVICE_INFO structure provides information about a Bluetooth
/// device.
///
/// {@category Struct}
class BLUETOOTH_DEVICE_INFO extends Struct {
  @Uint32()
  external int dwSize;
  @Uint64()
  external int Address;
  @Uint32()
  external int ulClassofDevice;
  @Int32()
  external int fConnected;
  @Int32()
  external int fRemembered;
  @Int32()
  external int fAuthenticated;

  external SYSTEMTIME stLastSeen;
  external SYSTEMTIME stLastUsed;

  @Uint64()
  external int _data0;
  @Uint64()
  external int _data1;
  @Uint64()
  external int _data2;
  @Uint64()
  external int _data3;
  @Uint64()
  external int _data4;
  @Uint64()
  external int _data5;
  @Uint64()
  external int _data6;
  @Uint64()
  external int _data7;
  @Uint64()
  external int _data8;
  @Uint64()
  external int _data9;
  @Uint64()
  external int _data10;
  @Uint64()
  external int _data11;
  @Uint64()
  external int _data12;
  @Uint64()
  external int _data13;
  @Uint64()
  external int _data14;
  @Uint64()
  external int _data15;
  @Uint64()
  external int _data16;
  @Uint64()
  external int _data17;
  @Uint64()
  external int _data18;
  @Uint64()
  external int _data19;
  @Uint64()
  external int _data20;
  @Uint64()
  external int _data21;
  @Uint64()
  external int _data22;
  @Uint64()
  external int _data23;
  @Uint64()
  external int _data24;
  @Uint64()
  external int _data25;
  @Uint64()
  external int _data26;
  @Uint64()
  external int _data27;
  @Uint64()
  external int _data28;
  @Uint64()
  external int _data29;
  @Uint64()
  external int _data30;
  @Uint64()
  external int _data31;
  @Uint64()
  external int _data32;
  @Uint64()
  external int _data33;
  @Uint64()
  external int _data34;
  @Uint64()
  external int _data35;
  @Uint64()
  external int _data36;
  @Uint64()
  external int _data37;
  @Uint64()
  external int _data38;
  @Uint64()
  external int _data39;
  @Uint64()
  external int _data40;
  @Uint64()
  external int _data41;
  @Uint64()
  external int _data42;
  @Uint32()
  external int _data43;
  @Uint64()
  external int _data44;
  @Uint64()
  external int _data45;
  @Uint64()
  external int _data46;
  @Uint64()
  external int _data47;
  @Uint64()
  external int _data48;
  @Uint64()
  external int _data49;
  @Uint64()
  external int _data50;
  @Uint64()
  external int _data51;
  @Uint64()
  external int _data52;
  @Uint32()
  external int _data53;
  @Uint64()
  external int _data54;
  @Uint64()
  external int _data55;
  @Uint64()
  external int _data56;
  @Uint64()
  external int _data57;
  @Uint64()
  external int _data58;
  @Uint64()
  external int _data59;
  @Uint64()
  external int _data60;
  @Uint64()
  external int _data61;
}

extension PointerBLUETOOTH_DEVICE_INFOExtension
    on Pointer<BLUETOOTH_DEVICE_INFO> {
  String get szName => cast<Uint8>()
      .elementAt(60)
      .cast<Utf16>()
      .unpackString(BLUETOOTH_MAX_NAME_SIZE);
}

// typedef struct _BLUETOOTH_DEVICE_SEARCH_PARAMS {
//   DWORD  dwSize;
//   BOOL   fReturnAuthenticated;
//   BOOL   fReturnRemembered;
//   BOOL   fReturnUnknown;
//   BOOL   fReturnConnected;
//   BOOL   fIssueInquiry;
//   UCHAR  cTimeoutMultiplier;
//   HANDLE hRadio;
// } BLUETOOTH_DEVICE_SEARCH_PARAMS;

/// The BLUETOOTH_DEVICE_SEARCH_PARAMS structure specifies search criteria for
/// Bluetooth device searches.
///
/// {@category Struct}
class BLUETOOTH_DEVICE_SEARCH_PARAMS extends Struct {
  @Int32()
  external int dwSize;
  @Int32()
  external int fReturnAuthenticated;
  @Int32()
  external int fReturnRemembered;
  @Int32()
  external int fReturnUnknown;
  @Int32()
  external int fReturnConnected;
  @Int32()
  external int fIssueInquiry;
  @Uint8()
  external int cTimeoutMultiplier;
  @IntPtr()
  external int hRadio;
}

// typedef struct BLUETOOTH_FIND_RADIO_PARAMS {
//   DWORD dwSize;
// } BLUETOOTH_FIND_RADIO_PARAMS;

/// The BLUETOOTH_FIND_RADIO_PARAMS structure facilitates enumerating installed
/// Bluetooth radios.
///
/// {@category Struct}
class BLUETOOTH_FIND_RADIO_PARAMS extends Struct {
  @Uint32()
  external int dwSize;
}

// typedef struct _BLUETOOTH_ADDRESS {
//   union {
//     BTH_ADDR ullLong;
//     BYTE     rgBytes[6];
//   };
// } BLUETOOTH_ADDRESS_STRUCT;

/// The BLUETOOTH_ADDRESS structure provides the address of a Bluetooth device.
///
/// {@category Struct}
class BLUETOOTH_ADDRESS extends Struct {
  @Uint64()
  external int ullLong;

  List<int> get rgBytes => [
        (ullLong & 0xFF),
        (ullLong & 0xFF00) >> 8,
        (ullLong & 0xFF0000) >> 16,
        (ullLong & 0xFF000000) >> 24,
        (ullLong & 0xFF00000000) >> 32,
        (ullLong & 0xFF0000000000) >> 40
      ];
}

// // typedef struct _BLUETOOTH_RADIO_INFO {
//   DWORD             dwSize;
//   BLUETOOTH_ADDRESS address;
//   WCHAR             szName[BLUETOOTH_MAX_NAME_SIZE];
//   ULONG             ulClassofDevice;
//   USHORT            lmpSubversion;
//   USHORT            manufacturer;
// } BLUETOOTH_RADIO_INFO, *PBLUETOOTH_RADIO_INFO;

/// The BLUETOOTH_RADIO_INFO structure contains information about a Bluetooth
/// radio.
///
/// {@category Struct}
class BLUETOOTH_RADIO_INFO extends Struct {
  @Uint32()
  external int dwSize;

  external BLUETOOTH_ADDRESS address;

  // WCHAR szName[ BLUETOOTH_MAX_NAME_SIZE ];
  @Uint64()
  external int _data0;
  @Uint64()
  external int _data1;
  @Uint64()
  external int _data2;
  @Uint64()
  external int _data3;
  @Uint64()
  external int _data4;
  @Uint64()
  external int _data5;
  @Uint64()
  external int _data6;
  @Uint64()
  external int _data7;
  @Uint64()
  external int _data8;
  @Uint64()
  external int _data9;
  @Uint64()
  external int _data10;
  @Uint64()
  external int _data11;
  @Uint64()
  external int _data12;
  @Uint64()
  external int _data13;
  @Uint64()
  external int _data14;
  @Uint64()
  external int _data15;
  @Uint64()
  external int _data16;
  @Uint64()
  external int _data17;
  @Uint64()
  external int _data18;
  @Uint64()
  external int _data19;
  @Uint64()
  external int _data20;
  @Uint64()
  external int _data21;
  @Uint64()
  external int _data22;
  @Uint64()
  external int _data23;
  @Uint64()
  external int _data24;
  @Uint64()
  external int _data25;
  @Uint64()
  external int _data26;
  @Uint64()
  external int _data27;
  @Uint64()
  external int _data28;
  @Uint64()
  external int _data29;
  @Uint64()
  external int _data30;
  @Uint64()
  external int _data31;
  @Uint64()
  external int _data32;
  @Uint64()
  external int _data33;
  @Uint64()
  external int _data34;
  @Uint64()
  external int _data35;
  @Uint64()
  external int _data36;
  @Uint64()
  external int _data37;
  @Uint64()
  external int _data38;
  @Uint64()
  external int _data39;
  @Uint64()
  external int _data40;
  @Uint64()
  external int _data41;
  @Uint64()
  external int _data42;
  @Uint32()
  external int _data43;
  @Uint64()
  external int _data44;
  @Uint64()
  external int _data45;
  @Uint64()
  external int _data46;
  @Uint64()
  external int _data47;
  @Uint64()
  external int _data48;
  @Uint64()
  external int _data49;
  @Uint64()
  external int _data50;
  @Uint64()
  external int _data51;
  @Uint64()
  external int _data52;
  @Uint32()
  external int _data53;
  @Uint64()
  external int _data54;
  @Uint64()
  external int _data55;
  @Uint64()
  external int _data56;
  @Uint64()
  external int _data57;
  @Uint64()
  external int _data58;
  @Uint64()
  external int _data59;
  @Uint64()
  external int _data60;
  @Uint64()
  external int _data61;

  @Uint32()
  external int ulClassOfDevice;
  @Uint16()
  external int lmpSubversion;
  @Uint16()
  external int manufacturer;
}

extension PointerBLUETOOTH_RADIO_INFOExtension
    on Pointer<BLUETOOTH_RADIO_INFO> {
  String get szName => cast<Uint8>()
      .elementAt(16)
      .cast<Utf16>()
      .unpackString(BLUETOOTH_MAX_NAME_SIZE);
}

// typedef struct _BLUETOOTH_PIN_INFO {
//   UCHAR pin[BTH_MAX_PIN_SIZE];
//   UCHAR pinLength;
// } BLUETOOTH_PIN_INFO, *PBLUETOOTH_PIN_INFO;

/// The BLUETOOTH_PIN_INFO structure contains information used for
/// authentication via PIN.
///
/// {@category Struct}
class BLUETOOTH_PIN_INFO extends Struct {
  @Int64()
  external int _data0;
  @Int64()
  external int _data1;
  @Int8()
  external int _data8;
}

extension PointerBLUETOOTH_PIN_INFOExtension on Pointer<BLUETOOTH_PIN_INFO> {
  int get pinLength => cast<Uint8>().elementAt(BTH_MAX_PIN_SIZE).value;

  set pinLength(int length) {
    cast<Uint8>().elementAt(BTH_MAX_PIN_SIZE).value =
        min(length, BTH_MAX_PIN_SIZE);
  }

  String get pin => String.fromCharCodes(cast<Uint8>().asTypedList(pinLength));

  set pin(String pinString) {
    final pinData = Uint8List.fromList(pinString.codeUnits);

    // Set up to the length of the string, even if longer than pinLength, since
    // user may set pin before pinLength.
    for (var idx = 0; idx < min(pinData.length, BTH_MAX_PIN_SIZE); idx++) {
      cast<Uint8>().elementAt(idx).value = pinData[idx];
    }
  }
}

// typedef struct _BLUETOOTH_OOB_DATA_INFO {
//   UCHAR C[16];
//   UCHAR R[16];
// } BLUETOOTH_OOB_DATA_INFO, *PBLUETOOTH_OOB_DATA_INFO;

/// The BLUETOOTH_OOB_DATA_INFO structure contains data used to authenticate
/// prior to establishing an Out-of-Band device pairing.
///
/// {@category Struct}
class BLUETOOTH_OOB_DATA_INFO extends Struct {
  @Int64()
  external int _data0;
  @Int64()
  external int _data1;
  @Int64()
  external int _data2;
  @Int64()
  external int _data3;
}

extension PointerBLUETOOTH_OOB_DATA_INFOExtension
    on Pointer<BLUETOOTH_OOB_DATA_INFO> {
  Uint8ClampedList get C => cast<Uint8>().asTypedList(16) as Uint8ClampedList;
  set C(Uint8ClampedList value) =>
      cast<Uint8>().asTypedList(16).setAll(0, value);

  Uint8ClampedList get R =>
      cast<Uint8>().elementAt(16).asTypedList(16) as Uint8ClampedList;
  set R(Uint8ClampedList value) =>
      cast<Uint8>().elementAt(16).asTypedList(16).setAll(0, value);
}

// typedef struct COR_FIELD_OFFSET
//     {
//     mdFieldDef ridOfField;
//     ULONG32 ulOffset;
//     } 	COR_FIELD_OFFSET;

/// Stores the offset, within a class, of the specified field.
///
/// {@category Struct}
class COR_FIELD_OFFSET extends Struct {
  @Uint32()
  external int ridOfField;

  @Uint32()
  external int ulOffset;
}

// typedef struct tagVS_FIXEDFILEINFO
// {
//     DWORD   dwSignature;
//     DWORD   dwStrucVersion;
//     DWORD   dwFileVersionMS;
//     DWORD   dwFileVersionLS;
//     DWORD   dwProductVersionMS;
//     DWORD   dwProductVersionLS;
//     DWORD   dwFileFlagsMask;
//     DWORD   dwFileFlags;
//     DWORD   dwFileOS;
//     DWORD   dwFileType;
//     DWORD   dwFileSubtype;
//     DWORD   dwFileDateMS;
//     DWORD   dwFileDateLS;
// } VS_FIXEDFILEINFO;

/// Contains version information for a file. This information is language and
/// code page independent.
///
/// {@category Struct}
class VS_FIXEDFILEINFO extends Struct {
  @Uint32()
  external int dwSignature;
  @Uint32()
  external int dwStrucVersion;
  @Uint32()
  external int dwFileVersionMS;
  @Uint32()
  external int dwFileVersionLS;
  @Uint32()
  external int dwProductVersionMS;
  @Uint32()
  external int dwProductVersionLS;
  @Uint32()
  external int dwFileFlagsMask;
  @Uint32()
  external int dwFileFlags;
  @Uint32()
  external int dwFileOS;
  @Uint32()
  external int dwFileType;
  @Uint32()
  external int dwFileSubtype;
  @Uint32()
  external int dwFileDateMS;
  @Uint32()
  external int dwFileDateLS;
}

// typedef struct tagMCI_OPEN_PARMSW {
//     DWORD_PTR   dwCallback;
//     MCIDEVICEID wDeviceID;
//     LPCWSTR    lpstrDeviceType;
//     LPCWSTR    lpstrElementName;
//     LPCWSTR    lpstrAlias;
// } MCI_OPEN_PARMSW, *PMCI_OPEN_PARMSW, *LPMCI_OPEN_PARMSW;

/// The MCI_OPEN_PARMS structure contains information for the MCI_OPEN command.
///
/// {@category Struct}
///
/// Packed struct -- 36 bytes on 64-bit, 20 bytes on 32-bit
class MCI_OPEN_PARMS extends Struct {
  @IntPtr()
  external int dwCallback;
  @Uint32()
  external int wDeviceID;
  external Pointer<Utf16> lpstrDeviceType;
  external Pointer<Utf16> lpstrElementName;
  external Pointer<Utf16> lpstrAlias;
}

// typedef struct {
//   DWORD_PTR dwCallback;
//   DWORD     dwFrom;
//   DWORD     dwTo;
// } MCI_PLAY_PARMS, *PMCI_PLAY_PARMS, FAR *LPMCI_PLAY_PARMS;

/// The MCI_PLAY_PARMS structure contains positioning information for the
/// MCI_PLAY command.
///
/// {@category Struct}
class MCI_PLAY_PARMS extends Struct {
  @IntPtr()
  external int dwCallback;
  @Uint32()
  external int dwFrom;
  @Uint32()
  external int dwTo;
}

// typedef struct tagMCI_SEEK_PARMS {
//     DWORD_PTR   dwCallback;
//     DWORD       dwTo;
// } MCI_SEEK_PARMS, *PMCI_SEEK_PARMS, FAR *LPMCI_SEEK_PARMS;

/// The MCI_SEEK_PARMS structure contains positioning information for the
/// MCI_SEEK command.
///
/// {@category Struct}
class MCI_SEEK_PARMS extends Struct {
  @IntPtr()
  external int dwCallback;
  @Uint32()
  external int dwTo;
}

// typedef struct tagLOGBRUSH {
//   UINT      lbStyle;
//   COLORREF  lbColor;
//   ULONG_PTR lbHatch;
// } LOGBRUSH, *PLOGBRUSH, *NPLOGBRUSH, *LPLOGBRUSH;

/// The LOGBRUSH structure defines the style, color, and pattern of a physical
/// brush. It is used by the CreateBrushIndirect and ExtCreatePen functions.
///
/// {@category Struct}
class LOGBRUSH extends Struct {
  @Uint32()
  external int lbStyle;
  @Int32()
  external int lbColor;
  external Pointer<Uint32> lbHatch;
}

// typedef struct tagMCI_STATUS_PARMS {
//     DWORD_PTR   dwCallback;
//     DWORD_PTR   dwReturn;
//     DWORD       dwItem;
//     DWORD       dwTrack;
// } MCI_STATUS_PARMS, *PMCI_STATUS_PARMS, FAR * LPMCI_STATUS_PARMS;

/// The MCI_STATUS_PARMS structure contains information for the MCI_STATUS command.
///
/// {@category Struct}
class MCI_STATUS_PARMS extends Struct {
  @IntPtr()
  external int dwCallback;
  @IntPtr()
  external int dwReturn;
  @Uint32()
  external int dwItem;
  @Uint32()
  external int dwTrack;
}

// typedef struct _OVERLAPPED {
//   ULONG_PTR Internal;
//   ULONG_PTR InternalHigh;
//   union {
//     struct {
//       DWORD Offset;
//       DWORD OffsetHigh;
//     } DUMMYSTRUCTNAME;
//     PVOID Pointer;
//   } DUMMYUNIONNAME;
//   HANDLE    hEvent;
// } OVERLAPPED, *LPOVERLAPPED;

/// Contains information used in asynchronous (or overlapped) input and output
/// (I/O).
///
/// {@category Struct}
class OVERLAPPED extends Struct {
  @IntPtr()
  external int Internal;

  @IntPtr()
  external int InternalHigh;

  external Pointer pointer;

  @IntPtr()
  external int hEvent;
}

// typedef struct tagACTCTXW {
//   ULONG   cbSize;
//   DWORD   dwFlags;
//   LPCWSTR lpSource;
//   USHORT  wProcessorArchitecture;
//   LANGID  wLangId;
//   LPCWSTR lpAssemblyDirectory;
//   LPCWSTR lpResourceName;
//   LPCWSTR lpApplicationName;
//   HMODULE hModule;
// } ACTCTXW, *PACTCTXW;

/// The ACTCTX structure is used by the CreateActCtx function to create the
/// activation context.
///
/// {@category Struct}
class ACTCTX extends Struct {
  @Uint32()
  external int cbSize;

  @Uint32()
  external int dwFlags;

  external Pointer<Utf16> lpSource;

  @Uint16()
  external int wProcessorArchitecture;

  @Uint16()
  external int wLangId;

  external Pointer<Utf16> lpAssemblyDirectory;
  external Pointer<Utf16> lpResourceName;
  external Pointer<Utf16> lpApplicationName;

  @IntPtr()
  external int hModule;
}

// typedef struct _WIN32_FIND_DATAW {
//   DWORD    dwFileAttributes;
//   FILETIME ftCreationTime;
//   FILETIME ftLastAccessTime;
//   FILETIME ftLastWriteTime;
//   DWORD    nFileSizeHigh;
//   DWORD    nFileSizeLow;
//   DWORD    dwReserved0;
//   DWORD    dwReserved1;
//   WCHAR    cFileName[MAX_PATH];
//   WCHAR    cAlternateFileName[14];
//   DWORD    dwFileType;
//   DWORD    dwCreatorType;
//   WORD     wFinderFlags;
// } WIN32_FIND_DATAW, *PWIN32_FIND_DATAW, *LPWIN32_FIND_DATAW;

/// Contains information about the file that is found by the FindFirstFile,
/// FindFirstFileEx, or FindNextFile function.
///
/// {@category Struct}
class WIN32_FIND_DATA extends Struct {
  @Uint32()
  external int dwFileAttributes;
  external FILETIME ftCreationTime;

  external FILETIME ftLastAccessTime;
  external FILETIME ftLastWriteTime;
  @Uint32()
  external int nFileSizeHigh;
  @Uint32()
  external int nFileSizeLow;
  @Uint32()
  external int dwReserved0;
  @Uint32()
  external int dwReserved1;

  // TODO: Pad for sizeOf
}

extension PointerWIN32_FIND_DATAExtension on Pointer<WIN32_FIND_DATA> {
  String get cFileName =>
      cast<Uint8>().elementAt(44).cast<Utf16>().unpackString(MAX_PATH);
  String get cAlternateFileName =>
      cast<Uint8>().elementAt(44 + MAX_PATH * 2).cast<Utf16>().unpackString(14);

  int get dwFileType =>
      cast<Uint8>().elementAt(44 + (MAX_PATH + 14) * 2).cast<Uint32>().value;
  int get dwCreatorType =>
      cast<Uint8>().elementAt(48 + (MAX_PATH + 14) * 2).cast<Uint32>().value;
  int get wFinderFlags =>
      cast<Uint8>().elementAt(52 + (MAX_PATH + 14) * 2).cast<Uint16>().value;
}

// typedef struct _NOTIFYICONDATAW {
//   DWORD cbSize;
//   HWND hWnd;
//   UINT uID;
//   UINT uFlags;
//   UINT uCallbackMessage;
//   HICON hIcon;
//   WCHAR  szTip[128];
//   DWORD dwState;
//   DWORD dwStateMask;
//   WCHAR  szInfo[256];
//   union {
//   UINT  uTimeout;
//   UINT  uVersion;  // used with NIM_SETVERSION, values 0, 3 and 4
//   } DUMMYUNIONNAME;
//   WCHAR  szInfoTitle[64];
//   DWORD dwInfoFlags;
//   #endif
//   GUID guidItem;
//   HICON hBalloonIcon;
//   #endif
// } NOTIFYICONDATAW, *PNOTIFYICONDATAW;

// TODO: This struct does not yet support uVersion
// FFI support for packed structs https://github.com/dart-lang/sdk/issues/38158

/// The NOTIFYICONDATA contains information that the system needs to display
/// notifications in the notification area. Used by Shell_NotifyIcon.
///
/// {@category Struct}
class NOTIFYICONDATA extends Struct {
  @Uint32()
  external int cbSize;

  @IntPtr()
  external int hWnd;

  @Uint32()
  external int uID;

  @Uint32()
  external int uFlags;

  @Uint32()
  external int uCallbackMessage;

  @IntPtr()
  external int hIcon;

  // WCHAR szTip[128]
  @Uint64()
  external int _wchar0_szTip;
  @Uint64()
  external int _wchar4_szTip;
  @Uint64()
  external int _wchar8_szTip;
  @Uint64()
  external int _wchar12_szTip;
  @Uint64()
  external int _wchar16_szTip;
  @Uint64()
  external int _wchar20_szTip;
  @Uint64()
  external int _wchar24_szTip;
  @Uint64()
  external int _wchar28_szTip;
  @Uint64()
  external int _wchar32_szTip;
  @Uint64()
  external int _wchar36_szTip;
  @Uint64()
  external int _wchar40_szTip;
  @Uint64()
  external int _wchar44_szTip;
  @Uint64()
  external int _wchar48_szTip;
  @Uint64()
  external int _wchar52_szTip;
  @Uint64()
  external int _wchar56_szTip;
  @Uint64()
  external int _wchar60_szTip;
  @Uint64()
  external int _wchar64_szTip;
  @Uint64()
  external int _wchar68_szTip;
  @Uint64()
  external int _wchar72_szTip;
  @Uint64()
  external int _wchar76_szTip;
  @Uint64()
  external int _wchar80_szTip;
  @Uint64()
  external int _wchar84_szTip;
  @Uint64()
  external int _wchar88_szTip;
  @Uint64()
  external int _wchar92_szTip;
  @Uint64()
  external int _wchar96_szTip;
  @Uint64()
  external int _wchar100_szTip;
  @Uint64()
  external int _wchar104_szTip;
  @Uint64()
  external int _wchar108_szTip;
  @Uint64()
  external int _wchar112_szTip;
  @Uint64()
  external int _wchar116_szTip;
  @Uint64()
  external int _wchar120_szTip;
  @Uint64()
  external int _wchar124_szTip;

  @Uint32()
  external int dwState;

  @Uint32()
  external int dwStateMask;

  // WCHAR szInfo[256]
  @Uint64()
  external int _wchar0_szInfo;
  @Uint64()
  external int _wchar4_szInfo;
  @Uint64()
  external int _wchar8_szInfo;
  @Uint64()
  external int _wchar12_szInfo;
  @Uint64()
  external int _wchar16_szInfo;
  @Uint64()
  external int _wchar20_szInfo;
  @Uint64()
  external int _wchar24_szInfo;
  @Uint64()
  external int _wchar28_szInfo;
  @Uint64()
  external int _wchar32_szInfo;
  @Uint64()
  external int _wchar36_szInfo;
  @Uint64()
  external int _wchar40_szInfo;
  @Uint64()
  external int _wchar44_szInfo;
  @Uint64()
  external int _wchar48_szInfo;
  @Uint64()
  external int _wchar52_szInfo;
  @Uint64()
  external int _wchar56_szInfo;
  @Uint64()
  external int _wchar60_szInfo;
  @Uint64()
  external int _wchar64_szInfo;
  @Uint64()
  external int _wchar68_szInfo;
  @Uint64()
  external int _wchar72_szInfo;
  @Uint64()
  external int _wchar76_szInfo;
  @Uint64()
  external int _wchar80_szInfo;
  @Uint64()
  external int _wchar84_szInfo;
  @Uint64()
  external int _wchar88_szInfo;
  @Uint64()
  external int _wchar92_szInfo;
  @Uint64()
  external int _wchar96_szInfo;
  @Uint64()
  external int _wchar100_szInfo;
  @Uint64()
  external int _wchar104_szInfo;
  @Uint64()
  external int _wchar108_szInfo;
  @Uint64()
  external int _wchar112_szInfo;
  @Uint64()
  external int _wchar116_szInfo;
  @Uint64()
  external int _wchar120_szInfo;
  @Uint64()
  external int _wchar124_szInfo;
  @Uint64()
  external int _wchar128_szInfo;
  @Uint64()
  external int _wchar132_szInfo;
  @Uint64()
  external int _wchar136_szInfo;
  @Uint64()
  external int _wchar140_szInfo;
  @Uint64()
  external int _wchar144_szInfo;
  @Uint64()
  external int _wchar148_szInfo;
  @Uint64()
  external int _wchar152_szInfo;
  @Uint64()
  external int _wchar156_szInfo;
  @Uint64()
  external int _wchar160_szInfo;
  @Uint64()
  external int _wchar164_szInfo;
  @Uint64()
  external int _wchar168_szInfo;
  @Uint64()
  external int _wchar172_szInfo;
  @Uint64()
  external int _wchar176_szInfo;
  @Uint64()
  external int _wchar180_szInfo;
  @Uint64()
  external int _wchar184_szInfo;
  @Uint64()
  external int _wchar188_szInfo;
  @Uint64()
  external int _wchar192_szInfo;
  @Uint64()
  external int _wchar196_szInfo;
  @Uint64()
  external int _wchar200_szInfo;
  @Uint64()
  external int _wchar204_szInfo;
  @Uint64()
  external int _wchar208_szInfo;
  @Uint64()
  external int _wchar212_szInfo;
  @Uint64()
  external int _wchar216_szInfo;
  @Uint64()
  external int _wchar220_szInfo;
  @Uint64()
  external int _wchar224_szInfo;
  @Uint64()
  external int _wchar228_szInfo;
  @Uint64()
  external int _wchar232_szInfo;
  @Uint64()
  external int _wchar236_szInfo;
  @Uint64()
  external int _wchar240_szInfo;
  @Uint64()
  external int _wchar244_szInfo;
  @Uint64()
  external int _wchar248_szInfo;
  @Uint64()
  external int _wchar252_szInfo;

  @Uint32()
  external int uTimeout;

  @Uint32()
  external int uVersion; // used with NIM_SETVERSION, values 0, 3 and 4

  // WCHAR szInfoTitle[64]
  @Uint64()
  external int _wchar0_szInfoTitle;
  @Uint64()
  external int _wchar4_szInfoTitle;
  @Uint64()
  external int _wchar8_szInfoTitle;
  @Uint64()
  external int _wchar12_szInfoTitle;
  @Uint64()
  external int _wchar16_szInfoTitle;
  @Uint64()
  external int _wchar20_szInfoTitle;
  @Uint64()
  external int _wchar24_szInfoTitle;
  @Uint64()
  external int _wchar28_szInfoTitle;
  @Uint64()
  external int _wchar32_szInfoTitle;
  @Uint64()
  external int _wchar36_szInfoTitle;
  @Uint64()
  external int _wchar40_szInfoTitle;
  @Uint64()
  external int _wchar44_szInfoTitle;
  @Uint64()
  external int _wchar48_szInfoTitle;
  @Uint64()
  external int _wchar52_szInfoTitle;
  @Uint64()
  external int _wchar56_szInfoTitle;
  @Uint64()
  external int _wchar60_szInfoTitle;

  @Uint32()
  external int dwInfoFlags;

  @Uint32()
  external int guidItem1;
  @Uint16()
  external int guidItem2;
  @Uint16()
  external int guidItem3;
  @Uint64()
  external int guidItem4;

  @IntPtr()
  external int hBalloonIcon;
}

extension Pointer_NOTIFYICONDATA_Extension on Pointer<NOTIFYICONDATA> {
  String get szTip =>
      cast<Uint8>().elementAt(40).cast<Utf16>().unpackString(128);

  set szTip(String text63chars) {
    if (text63chars.length > 63) {
      throw ArgumentError('Argument "text64chars" should be less 63 char');
    }
    _wchar_cpy(this, 40, text63chars);
  }

  String get szInfo =>
      cast<Uint8>().elementAt(304).cast<Utf16>().unpackString(256);

  set szInfo(String text255chars) {
    if (text255chars.length > 255) {
      throw ArgumentError('Argument "text255chars" should be less 255 chars');
    }
    _wchar_cpy(this, 304, text255chars);
  }

  String get szInfoTitle =>
      cast<Uint8>().elementAt(824).cast<Utf16>().unpackString(64);

  set szInfoTitle(String text63chars) {
    if (text63chars.length > 63) {
      throw ArgumentError('Argument "text63chars" should be less 63 chars');
    }
    _wchar_cpy(this, 824, text63chars);
  }

  static void _wchar_cpy(Pointer pointer, int memStart, String source) {
    final units = source.codeUnits;
    final szMemory = pointer.cast<Uint8>();

    for (var i = 0; i < units.length; i++) {
      szMemory.elementAt(memStart + i * 2).value = units[i];
    }
    szMemory.elementAt(memStart + units.length * 2).value = 0;
  }
}

// typedef struct tagTPMPARAMS {
//   UINT cbSize;
//   RECT rcExclude;
// } TPMPARAMS;

/// Contains extended parameters for the TrackPopupMenuEx function.
///
/// {@category Struct}
class TPMPARAMS extends Struct {
  @Uint32()
  external int cbSize;

  external RECT rcExclude;
}

// TODO: remove this
class EXCEPINFO extends Struct {}
class NLM_SIMULATED_PROFILE_INFO extends Struct {}
class _GetClassID_Dart extends Struct {}
class PROPERTYKEY extends Struct {}
class CLSID extends Struct {}
class STATSTG extends Struct {}
class SAFEARRAY extends Struct {}
class PROPVARIANT extends Struct {}
