part of ccompilers.ccompilers;

/**
 * Gnu Linker is a wrapper over the [Gcc] class.
 * Main purpose is to simplify writing code to execute a `gcc` linker.
 *
 * Example:
 *     var files = ["hello.obj"];
 *     var args = ["-shared"];
 *     var linker = new GnuLinker();
 *     linker.link(files, arguments: args, libpaths: libpaths, output: "hello");
 */
class GnuLinker extends Gcc implements EasyLinker {
  int _bits;

  GnuLinker({int bits, Logger logger}) : super(logger: logger) {
    if (!(bits == null || bits == 32 || bits == 64)) {
      throw new ArgumentError("bits: $bits");
    }

    _bits = bits;
  }

  /**
   * Links the [input] files and returns the [ProcessResult] result.
   */
  ProcessResult link(List<String> input,
      {List<String> arguments,
      Map<String, String> environment,
      List<String> libpaths,
      String output,
      String workingDirectory}) {
    if (input == null) {
      throw new ArgumentError("input: $input");
    }

    var args = new CommandLineArguments();
    args.add('-m32', test: _bits == 32);
    args.add('-m64', test: _bits == 64);
    if (output != null) {
      args.add(output, prefix: '-o');
    }

    if (libpaths != null) {
      args.addAll(libpaths, prefix: '-L');
    }

    args.addAll(input);
    if (arguments != null) {
      args.addAll(arguments);
    }

    return run(args.arguments,
        environment: environment, workingDirectory: workingDirectory);
  }
}
