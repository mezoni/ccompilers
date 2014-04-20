part of ccompilers.ccompilers;

class CommandLineTask {
  Function _action;

  String after;

  String before;

  String fail;

  ProcessResult result;

  bool silent;

  String success;

  CommandLineTask(ProcessResult
      action(), {this.after, this.before, this.fail, this.silent, this.success}) {
    _action = action;
  }

  ProcessResult execute() {
    _write(before);
    result = _action();
    _write(after);
    if (result.exitCode == 0) {
      _write(success);
    } else {
      _write(fail);
    }

    return result;
  }

  void _write(String message, {bool error}) {
    if (silent == true) {
      return;
    }

    if (message == null || message.isEmpty) {
      return;
    }

    if (error == true) {
      stderr.writeln(message);
    } else {
      print(message);
    }
  }
}
