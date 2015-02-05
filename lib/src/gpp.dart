part of ccompilers.ccompilers;

class Gpp extends CommandLineTool {
  Gpp({Logger logger}) : super(logger: logger) {
    executable = 'g++';
  }
}
