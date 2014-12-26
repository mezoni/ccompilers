part of ccompilers.ccompilers;

final String DART_SDK = DartSDK.path;

class DartSDK {
  /**
   * The path to Dart SDK.
   */
  static String get path {
    var path = _findPathToDartVM();
    if (path != null) {
      path = pathos.dirname(path);
      if (path != ".") {
        var required = pathos.join(path, "include", "dart_api.h");
        if (new File(required).existsSync()) {
          return path;
        }
      }
    }

    // Can be problematic when using multiple SDK on local machine.
    path = Platform.environment['DART_SDK'];
    if (path == null) {
      return null;
    }

    return pathos.normalize(path);
  }

  /**
   * Returns the bitness of Dart Virtual Machine.
   */
  static int getVmBits() => SysInfo.userSpaceBitness;

  static String _findPathToDartVM() {
    // TODO: See https://code.google.com/p/dart/issues/detail?id=16994
    // Also exist other better way but I do not want introduce it here
    // because it is the responsibility of the Google Dart developers.
    // 26 Dec 2014
    var path = pathos.dirname(Platform.executable);
    if (path != ".") {
      return path;
    }

    return null;
  }
}
