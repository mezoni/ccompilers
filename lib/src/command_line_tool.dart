part of ccompilers.ccompilers;

/**
 * Command line tool.
 */
abstract class CommandLineTool {
  /**
   * The name of executable program.
   */
  String executable;

  /**
   * Logger that logs the events.
   */
  Logger logger;

  /**
   * The path to executable program.
   */
  String path;

  CommandLineTool({this.logger});

  ProcessResult run(List<String> arguments, {String workingDirectory, Map<String, String> environment, bool includeParentEnvironment: true, bool runInShell: false, Encoding stdoutEncoding: SYSTEM_ENCODING, Encoding stderrEncoding: SYSTEM_ENCODING}) {
    environment = setEnvironment(environment);
    var filepath = executable;
    if (path != null) {
      filepath = pathos.join(path, executable);
    }

    var encoder = new JsonEncoder();
    var info = {};
    info["subject"] = runtimeType.toString();
    info["operation"] = "run";
    info["parameters"] = {
      "executable": filepath,
      "arguments": arguments
    };
    var logEntry = encoder.convert(info);
    if (logger != null) {
      logger.info(logEntry);
    }

    var result = Process.runSync(filepath, arguments, workingDirectory: workingDirectory, environment: environment, includeParentEnvironment: includeParentEnvironment, runInShell: runInShell, stdoutEncoding: stdoutEncoding, stderrEncoding: stderrEncoding);
    var message = result.stdout.toString();
    if (!message.isEmpty) {
      print(message);
    }

    message = result.stderr.toString();
    if (!message.isEmpty) {
      stderr.writeln(message);
    }

    return result;
  }

  /**
   * Sets the environment variables.
   */
  Map<String, String> setEnvironment(Map<String, String> environment) {
    if (environment == null) {
      environment = {};
    }

    environment.addAll(Platform.environment);
    return environment;
  }
}
