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

  /**
   * Links the [input] files and returns the [ProcessResult] result.
   */
  ProcessResult link(List<String> input, {List<String> arguments, List<String>
      libpaths, String output}) {
    if (input == null) {
      throw new ArgumentError("input: $input");
    }

    var args = new CommandLineArguments();
    if (libpaths != null) {
      args.addAll(libpaths, prefix: '-L');
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
