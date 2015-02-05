part of ccompilers.ccompilers;

class Gcc extends CommandLineTool {
  Gcc({Logger logger}) : super(logger: logger) {
    executable = 'gcc';
  }
}
