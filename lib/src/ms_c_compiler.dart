part of ccompilers.ccompilers;

/**
 * Microsoft C Compiler is a wrapper over the [Msvc] class.
 * Main purpose is to simplify writing code to execute a `cl` compiler.
 *
 * Example:
 *     var files = ["hello.c"];
 *     var args = ["/Og"];
 *     var compiler = new MsCCompiler();
 *     compiler.compile(files, arguments: args, define: define,
 *        include: include, output: "hello");
 */
class MsCCompiler extends Msvc implements CompilerTool {
  MsCCompiler({int bits, Logger logger}) : super(bits: bits, logger: logger);

  /**
   * Compiles C [input] files and returns the [ProcessResult] result.
   */
  ProcessResult compile(List<String> input,
      {List<String> arguments,
      Map<String, String> environment,
      Map<String, String> define,
      List<String> include,
      String output,
      String workingDirectory}) {
    if (input == null) {
      throw new ArgumentError("input: $input");
    }

    var args = new CommandLineArguments();
    args.add('/c');
    if (define != null) {
      args.addKeys(define, prefix: '/D');
    }

    if (include != null) {
      args.addAll(include, prefix: '/I');
    }

    args.addAll(input);
    if (output != null) {
      args.add(output, prefix: '/Fo');
    }

    if (arguments != null) {
      args.addAll(arguments);
    }

    return run(args.arguments,
        environment: environment, workingDirectory: workingDirectory);
  }
}
