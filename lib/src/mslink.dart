part of ccompilers.ccompilers;

class Mslink extends MsvsTool {
  Mslink({int bits}) : super(bits: bits) {
    executable = 'link.exe';
  }
}
