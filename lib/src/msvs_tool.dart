part of ccompilers.ccompilers;

abstract class MsvsTool extends CommandLineTool {
  int _bits;

  MsvsTool({int bits, Logger logger}) : super(logger: logger) {
    if (!(bits == null || bits == 32 || bits == 64)) {
      throw new ArgumentError('bits: $bits');
    }

    if (bits == null) {
      bits = WindowsUtils.getSystemBits();
    }

    _bits = bits;
  }

  Map<String, String> setEnvironment(Map<String, String> environment) {
    environment = super.setEnvironment(environment);
    var msvcEnvironment = MsvcUtils.getEnvironment(_bits);
    if (msvcEnvironment == null) {
      throw new StateError('Cannot set environment of the Visual Studio C/C++ compiler.');
    }

    environment.addAll(MsvcUtils.getEnvironment(_bits));
    var file = WindowsUtils.findFileInEnvPath(environment, executable);
    if (file != null) {
      path = pathos.dirname(file);
    }

    return environment;
  }
}
