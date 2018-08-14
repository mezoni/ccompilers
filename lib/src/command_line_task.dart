part of ccompilers.ccompilers;

/**
 * Command line task.
 */
class CommandLineTask {
  /**
   * The message which displayed after execution of this task.
   */
  String after;

  /**
   * The message which displayed before execution of this task.
   */
  String before;

  /**
   * The message which displayed after an unsuccessful execution of this task.
   */
  String fail;

  /**
   * The result of execution this task.
   */
  ProcessResult result;

  /**
   * If silent is true that no messages are displayed; otherwise displayed all
   * messages.
   */
  bool silent;

  /**
   * The message which displayed after successful execution of this task.
   */
  String success;

  ProcessResult Function() _action;

  CommandLineTask(ProcessResult action(),
      {this.after, this.before, this.fail, this.silent, this.success}) {
    _action = action;
  }

  /**
   * Executes the task action.
   */
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
