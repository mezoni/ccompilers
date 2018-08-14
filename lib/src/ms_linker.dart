part of ccompilers.ccompilers;

/**
 * Microsoft Linker is a wrapper over the [Mslink] class.
 * Main purpose is to simplify writing code to execute a `link` linker.
 *
 * Example:
 *     var files = ["hello.obj"];
 *     var args = ["/DLL"];
 *     var linker = new MsLinker();
 *     linker.link(files, arguments: args, libpaths: libpaths, output: "hello");
 */
class MsLinker extends Mslink implements EasyLinker {
  MsLinker({int bits, Logger logger}) : super(bits: bits, logger: logger);

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
    if (libpaths != null) {
      args.addAll(libpaths, prefix: '/LIBPATH:');
    }

    if (output != null) {
      args.add(output, prefix: '/OUT:');
    }

    args.addAll(input);
    if (arguments != null) {
      args.addAll(arguments);
    }

    return run(args.arguments,
        environment: environment, workingDirectory: workingDirectory);
  }
}
