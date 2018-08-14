part of ccompilers.ccompilers;

abstract class CompilerTool {
  ProcessResult compile(List<String> input,
      {List<String> arguments,
      Map<String, String> define,
      List<String> include,
      String output});
}
