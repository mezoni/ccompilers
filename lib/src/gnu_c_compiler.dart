part of ccompilers.ccompilers;

/**
 * Gnu C Compiler is a wrapper over the [Gcc] class.
 * Main purpose is to simplify writing code to execute a `gcc` compiler.
 *
 * Example:
 *     var files = ["hello.c"];
 *     var args = ["-fPIC", "-Wall"];
 *     var compiler = new GnuCCompiler();
 *     compiler.compile(files, arguments: args, define: define,
 *        include: include, output: "hello");
 */
class GnuCCompiler extends Gcc implements CompilerTool {
  int _bits;

  GnuCCompiler({int bits, Logger logger}) : super(logger: logger) {
    if (!(bits == null || bits == 32 || bits == 64)) {
      throw new ArgumentError("bits: $bits");
    }

    _bits = bits;
  }

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
    args.add('-c');
    args.add('-m32', test: _bits == 32);
    args.add('-m64', test: _bits == 64);
    if (define != null) {
      args.addKeys(define, prefix: '-D');
    }

    if (include != null) {
      args.addAll(include, prefix: '-I');
    }

    args.addAll(input);
    if (output != null) {
      args.add(output, prefix: '-o');
    }

    if (arguments != null) {
      args.addAll(arguments);
    }

    return run(args.arguments,
        environment: environment, workingDirectory: workingDirectory);
  }
}
