part of ccompilers.ccompilers;

final String DART_SDK = DartSDK.path;

class DartSDK {
  /**
   * The path to Dart SDK.
   */
  static String get path {
    var path = Platform.environment['DART_SDK'];
    if (path == null) {
      return null;
    }

    if (path.endsWith('\\') || path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    return path;
  }

  /**
   * Returns the bitness of Dart Virtual Machine.
   */
  static int getVmBits() => SysInfo.userSpaceBitness;
}
