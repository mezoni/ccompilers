part of ccompilers.ccompilers;

class Mslink extends MsvsTool {
  Mslink({int bits, Logger logger}) : super(bits: bits, logger: logger) {
    executable = 'link.exe';
  }
}
