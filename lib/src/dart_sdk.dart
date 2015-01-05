part of ccompilers.ccompilers;

final String DART_SDK = DartSDK.path;

class DartSDK {
  /**
   * The path to Dart SDK.
   */
  static final String path = _findPathToDartVM();

  /**
   * Returns the bitness of Dart Virtual Machine.
   */
  static int getVmBits() => SysInfo.userSpaceBitness;

  static String _findPathToDartVM() {
    var executable = Platform.executable;
    var s = Platform.pathSeparator;
    if (!executable.contains(s)) {
      if (Platform.isLinux) {
        executable = new Link("/proc/$pid/exe").resolveSymbolicLinksSync();
      } else {
        return null;
      }
    }

    var file = new File(executable);
    if (file.existsSync()) {
      var parent = file.absolute.parent;
      parent = parent.parent;
      var path = parent.path;
      var dartAPI = "$path${s}include${s}dart_api.h";
      if (new File(dartAPI).existsSync()) {
        return path;
      }
    }

    return null;
  }
}
