part of ccompilers.ccompilers;

class Msvc extends MsvsTool {
  Msvc({int bits}) : super(bits: bits) {
    executable = 'cl.exe';
  }
}
