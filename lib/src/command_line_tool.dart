part of ccompilers.ccompilers;

abstract class CommandLineTool {
  String executable;

  String path;

  CommandLineTool();

  ProcessResult run(List <String> arguments, {String workingDirectory, Map<String, String> environment, bool includeParentEnvironment, bool runInShell, Encoding stdoutEncoding: SYSTEM_ENCODING, Encoding stderrEncoding: SYSTEM_ENCODING}) {
    environment = setEnvironment(environment);
    var filepath = executable;
    if(path != null) {
      filepath = pathos.join(path, executable);
    }

    var result = Process.runSync(filepath, arguments, workingDirectory: workingDirectory, environment: environment, includeParentEnvironment: includeParentEnvironment, runInShell: runInShell, stdoutEncoding: stdoutEncoding, stderrEncoding: stderrEncoding);
    var message = result.stdout.toString();
    if(!message.isEmpty) {
      print(message);
    }

    message = result.stderr.toString();
    if(!message.isEmpty) {
      stderr.writeln(message);
    }

    return result;
  }

  Map<String, String> setEnvironment(Map<String, String> environment) {
    if(environment == null) {
      environment = {};
    }

    environment.addAll(Platform.environment);
    return environment;
  }
}
