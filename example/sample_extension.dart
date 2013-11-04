library ccompile.example.sample_extension;

import "dart-ext:sample_extension";

class SysInfo {
  static bool isLittleEndian = _isLittleEndian();

  static final int pageSize = _getPageSize();

  static final int sizeOfInt = _getSizeOfInt();

  static final String version = _getVersionString();

  static int _getPageSize() native "GetPageSize";

  static int _getSizeOfInt() native "GetSizeOfInt";

  static String _getVersionString() native "GetVersionString";

  static bool _isLittleEndian() native "IsLittleEndian";
}
