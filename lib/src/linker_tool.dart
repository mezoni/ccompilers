part of ccompilers.ccompilers;

abstract class EasyLinker {
  ProcessResult link(List<String> input, {List<String> arguments, List<String> libpaths, String output});
}
