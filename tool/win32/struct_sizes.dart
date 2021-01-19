// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Struct sizes are a mapping of name to 32-bit and 64-bit sizes
const structSize64 = {
  'WNDCLASS': 72,
  'SYSTEM_INFO': 48,
  'PROCESS_INFORMATION': 24,
  'STARTUPINFO': 104,
  'BIND_OPTS': 16,
  'SYSTEM_POWER_STATUS': 12,
  'SYSTEM_BATTERY_STATE': 32,
  'STARTUPINFOEX': 112,
  'SECURITY_ATTRIBUTES': 24,
  'SECURITY_DESCRIPTOR': 40,
  'SOLE_AUTHENTICATION_SERVICE': 24,
  'VARIANT': 24,
  'COMDLG_FILTERSPEC': 16,
  'ACCEL': 6,
  'MONITORINFO': 40,
  'PHYSICAL_MONITOR': 264,
  'SYSTEMTIME': 16,
  'CHOOSECOLOR': 72,
  'FINDREPLACE': 80,
  'CHOOSEFONT': 104,
  'OPENFILENAME': 152,
  'LOGFONT': 92,
  'ENUMLOGFONTEX': 348,
  'CREATESTRUCT': 80,
  'MENUINFO': 40,
  'MENUITEMINFO': 80,
  'MSG': 48,
  'SIZE': 8,
  'MINMAXINFO': 40,
  'POINT': 8,
  'PAINTSTRUCT': 72,
  'RECT': 16,
  'INPUT': 40,
  'TEXTMETRIC': 60,
  'SCROLLINFO': 28,
  'SHELLEXECUTEINFO': 112,
  'SHQUERYRBINFO': 24,
  'GUID': 16,
  'CREDENTIAL_ATTRIBUTE': 24,
  'CREDENTIAL': 80,
  'WINDOWINFO': 60,
  'BITMAPINFO': 44,
  'BITMAP': 32,
  'BITMAPFILEHEADER': 14,
  'BITMAPINFOHEADER': 40,
  'PALETTEENTRY': 4,
  'DRAWTEXTPARAMS': 20,
  'FILETIME': 8,
  'KNOWNFOLDER_DEFINITION': 112,
  'SHITEMID': 3,
  'DISPPARAMS': 24,
  'CONSOLE_CURSOR_INFO': 8,
  'CONSOLE_SCREEN_BUFFER_INFO': 22,
  'CONSOLE_SELECTION_INFO': 16,
  'COORD': 4,
  'CHAR_INFO': 4,
  'SMALL_RECT': 8,
  'INITCOMMONCONTROLSEX': 8,
  'DLGTEMPLATE': 18,
  'DLGITEMTEMPLATE': 18,
  'TASKDIALOGCONFIG': 160,
  'TASKDIALOG_BUTTON': 12,
  'DLLVERSIONINFO': 20,
  'OSVERSIONINFO': 276,
  'BLUETOOTH_ADDRESS': 8,
  'BLUETOOTH_DEVICE_INFO': 560,
  'BLUETOOTH_RADIO_INFO': 520,
  'BLUETOOTH_DEVICE_SEARCH_PARAMS': 40,
  'BLUETOOTH_FIND_RADIO_PARAMS': 4,
  'BLUETOOTH_PIN_INFO': 17,
  'BLUETOOTH_OOB_DATA_INFO': 32,
  'COR_FIELD_OFFSET': 8,
  'VS_FIXEDFILEINFO': 52,
  'MCI_OPEN_PARMS': 36,
  'MCI_PLAY_PARMS': 16,
  'MCI_SEEK_PARMS': 12,
  'MCI_STATUS_PARMS': 24,
  'LOGBRUSH': 16,
  'EXCEPINFO': 64,
  'PROPERTYKEY': 20,
  'PROPVARIANT': 24,
  'SAFEARRAY': 32,
  'CLSID': 16,
  'STATSTG': 80,
  'NLM_SIMULATED_PROFILE_INFO': 524,
};

const structSize32 = {
  'WNDCLASS': 40,
  'SYSTEM_INFO': 36,
  'PROCESS_INFORMATION': 16,
  'STARTUPINFO': 68,
  'BIND_OPTS': 16,
  'SYSTEM_POWER_STATUS': 12,
  'SYSTEM_BATTERY_STATE': 32,
  'STARTUPINFOEX': 72,
  'SECURITY_ATTRIBUTES': 12,
  'SECURITY_DESCRIPTOR': 20,
  'SOLE_AUTHENTICATION_SERVICE': 16,
  'VARIANT': 16,
  'COMDLG_FILTERSPEC': 8,
  'ACCEL': 6,
  'MONITORINFO': 40,
  'PHYSICAL_MONITOR': 260,
  'SYSTEMTIME': 16,
  'CHOOSECOLOR': 36,
  'FINDREPLACE': 40,
  'CHOOSEFONT': 60,
  'OPENFILENAME': 88,
  'LOGFONT': 92,
  'ENUMLOGFONTEX': 348,
  'CREATESTRUCT': 48,
  'MENUINFO': 28,
  'MENUITEMINFO': 48,
  'MSG': 28,
  'SIZE': 8,
  'MINMAXINFO': 40,
  'POINT': 8,
  'PAINTSTRUCT': 64,
  'RECT': 16,
  'INPUT': 28,
  'TEXTMETRIC': 60,
  'SCROLLINFO': 28,
  'SHELLEXECUTEINFO': 60,
  'SHQUERYRBINFO': 20,
  'GUID': 16,
  'CREDENTIAL_ATTRIBUTE': 16,
  'CREDENTIAL': 52,
  'WINDOWINFO': 60,
  'BITMAPINFO': 44,
  'BITMAP': 24,
  'BITMAPFILEHEADER': 14,
  'BITMAPINFOHEADER': 40,
  'PALETTEENTRY': 4,
  'DRAWTEXTPARAMS': 20,
  'FILETIME': 8,
  'KNOWNFOLDER_DEFINITION': 76,
  'SHITEMID': 3,
  'DISPPARAMS': 16,
  'CONSOLE_CURSOR_INFO': 8,
  'CONSOLE_SCREEN_BUFFER_INFO': 22,
  'CONSOLE_SELECTION_INFO': 16,
  'COORD': 4,
  'CHAR_INFO': 4,
  'SMALL_RECT': 8,
  'INITCOMMONCONTROLSEX': 8,
  'DLGTEMPLATE': 18,
  'DLGITEMTEMPLATE': 18,
  'TASKDIALOGCONFIG': 96,
  'TASKDIALOG_BUTTON': 8,
  'DLLVERSIONINFO': 20,
  'OSVERSIONINFO': 276,
  'BLUETOOTH_ADDRESS': 8,
  'BLUETOOTH_DEVICE_INFO': 560,
  'BLUETOOTH_RADIO_INFO': 520,
  'BLUETOOTH_DEVICE_SEARCH_PARAMS': 32,
  'BLUETOOTH_FIND_RADIO_PARAMS': 4,
  'BLUETOOTH_PIN_INFO': 17,
  'BLUETOOTH_OOB_DATA_INFO': 32,
  'COR_FIELD_OFFSET': 8,
  'VS_FIXEDFILEINFO': 52,
  'MCI_OPEN_PARMS': 20,
  'MCI_PLAY_PARMS': 12,
  'MCI_SEEK_PARMS': 8,
  'MCI_STATUS_PARMS': 16,
  'LOGBRUSH': 12,
  'EXCEPINFO': 32,
  'PROPERTYKEY': 20,
  'PROPVARIANT': 16,
  'SAFEARRAY': 24,
  'CLSID': 16,
  'STATSTG': 72,
  'NLM_SIMULATED_PROFILE_INFO': 524
};

const skipStructs = [
  // sizeOf<ENUMLOGFONTEX> returns 352 because Dart over-allocates storage.
  'ENUMLOGFONTEX',

  // sizeOf<SHITEMID> returns 4 because Dart over-allocates storage.
  'SHITEMID',

  // sizeOf<OSVERSIONINFO> returns 280 because Dart over-allocates storage.
  'OSVERSIONINFO',

  // sizeOf<BLUETOOTH_PIN_INFO> returns 24 because Dart over-allocates storage.
  'BLUETOOTH_PIN_INFO',

  // Should be allocated manually, rather than using sizeOf
  'DLGTEMPLATE', 'DLGITEMTEMPLATE',

  // TODO: Packed structs
  'MCI_OPEN_PARMS', 'MCI_SEEK_PARMS',
  'TASKDIALOGCONFIG', 'TASKDIALOG_BUTTON',
  'BITMAPFILEHEADER',

  // TODO: These are not yet implemented
  'EXCEPINFO',
  'PROPERTYKEY',
  'PROPVARIANT',
  'SAFEARRAY',
  'CLSID',
  'STATSTG',
  'NLM_SIMULATED_PROFILE_INFO'
];
