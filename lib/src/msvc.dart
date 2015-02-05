part of ccompilers.ccompilers;

class Msvc extends MsvsTool {
  Msvc({int bits, Logger logger}) : super(bits: bits, logger: logger) {
    executable = 'cl.exe';
  }
}
