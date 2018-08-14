part of ccompilers.ccompilers;

class MsvcUtils {
  static String getEnvironmentScript(int bits) {
    if (bits == null || (bits != 32 && bits != 64)) {
      throw new ArgumentError('bits: $bits');
    }

    var key = r'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio';
    if (SysInfo.kernelBitness == 64) {
      key = r'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio';
    }

    var reg = WindowsRegistry.queryAllKeys(key);
    if (reg == null) {
      return null;
    }

    var regVC7 = reg[r'SxS\VC7'];
    if (regVC7 == null) {
      return null;
    }

    var versions = [];
    for (var version in reg.keys.keys) {
      if (regVC7.values.containsKey(version)) {
        versions.add(regVC7.values[version].value);
      }
    }

    if (versions.length == 0) {
      return null;
    }

    var scriptName = 'vcvars32.bat';
    switch (bits) {
      case 64:
        switch (SysInfo.kernelArchitecture) {
          case "AMD64":
            scriptName = 'amd64\\vcvars64.bat';
            break;
          case "IA64":
            scriptName = 'ia64\\vcvars64.bat';
            break;
          default:
            return null;
        }

        break;
    }

    var fullScriptPath = '';
    for (var i = versions.length; i > 0; i--) {
      var vc7Path = versions[i - 1];
      var file = new File('${vc7Path}bin\\$scriptName');

      if (file.existsSync()) {
        fullScriptPath = file.path;
        break;
      }
    }

    if (fullScriptPath.isEmpty) {
      return null;
    }

    return fullScriptPath;
  }

  // TODO: Add support of Microsoft SDK
  static Map<String, String> getEnvironment(int bits) {
    if (bits == null || (bits != 32 && bits != 64)) {
      throw new ArgumentError('bits: $bits');
    }

    var script = getEnvironmentScript(bits);
    if (script == null) {
      return null;
    }

    var executable = '"$script" && set';
    var result = Process.runSync(executable, []);
    if (result != null && result.exitCode == 0) {
      var env = new Map<String, String>();
      var exp = new RegExp(r'(^\S+)=(.*)$', multiLine: true);
      var matches = exp.allMatches(result.stdout as String);
      for (var match in matches) {
        env[match.group(1)] = match.group(2);
      }

      return env;
    }

    return null;
  }
}
