part of ccompilers.ccompilers;

/**
 * Gnu C++ Compiler is a wrapper over the [Gpp] class.
 * Main purpose is to simplify writing code to execute a `gpp` compiler.
 *
 * Example:
 *     var files = ["hello.cpp"];
 *     var args = ["-fPIC", "-Wall"];
 *     var compiler = new GnuCppCompiler();
 *     compiler.compile(files, arguments: args, define: define,
 *        include: include, output: "hello");
 */
class GnuCppCompiler extends Gpp implements CompilerTool {
  int _bits;

  GnuCppCompiler([int bits]) {
    if (!(bits == null || bits == 32 || bits == 64)) {
      throw new ArgumentError("bits: $bits");
    }

    _bits = bits;
  }

  /**
   * Compiles C++ [input] files and returns the [ProcessResult] result.
   */
  ProcessResult compile(List<String> input, {List<String> arguments, Map<String, String> define, List<String> include, String output}) {
    if (input == null) {
      throw new ArgumentError("input: $input");
    }

    var args = new CommandLineArguments();
    args.add('-c');
    args.add('-m32', test: _bits == 32);
    args.add('-m64', test: _bits == 64);
    if (include != null) {
      args.addAll(include, prefix: '-I');
    }

    if (define != null) {
      args.addKeys(define, prefix: '-D');
    }

    if (output != null) {
      args.add(output, prefix: '-o');
    }

    if (arguments != null) {
      args.addAll(arguments);
    }

    args.addAll(input);
    return run(args.arguments);
  }
}
