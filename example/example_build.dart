library ccompilers.bin.example_build;

import 'dart:io';
import 'package:ccompilers/ccompilers.dart';

void main() {
  var result = new Project().run();
  exit(result);
}

class Project {
  CommandLineTool _compiler;
  CommandLineArguments _compilerArgs;
  CommandLineTool _linker;
  CommandLineArguments _linkerArgs;
  String _operatingSystem;

  int _bits;
  Map _compilerDefine = {};
  List _compilerInclude = ['$DART_SDK/bin', '$DART_SDK/include'];
  List _compilerInput = ['sample_extension.cc'];
  List _linkerInput = ['sample_extension'];
  List _linkerLibpath = [];
  String _linkerOutput = 'sample_extension';

  int _build() {
    var tasks = new List<CommandLineTask>();
    var compile = new CommandLineTask(() => _compiler.run(_compilerArgs.arguments));
    compile.before = 'Compile...';
    compile.success = 'Compilation succesful.';
    compile.fail = 'Compilation failed.';
    tasks.add(compile);
    var link = new CommandLineTask(() => _linker.run(_linkerArgs.arguments));
    link.before = 'Link...';
    link.success = 'Link succesful.';
    link.fail = 'Link failed.';
    tasks.add(link);
    for(var task in tasks) {
      var result = task.execute();
      if(result.exitCode != 0) {
        return result.exitCode;
      }
    }

    return 0;
  }

  void _setupArgumentsForPosixCompiler() {
    // Compiler
    var args = _compilerArgs;
    args.add('-c');
    args.addAll(['-fPIC', '-Wall']);
    args.add('-m32', test: _bits == 32);
    args.add('-m64', test: _bits == 64);
    args.addAll(_compilerInclude, prefix: '-I');
    args.addKeys(_compilerDefine, prefix: '-D');
    args.addAll(_compilerInput);
  }

  void _setupArgumentsForPosixLinker() {
    // Linker
    var args = _linkerArgs;
    args.addAll(_addExtension(_linkerInput, '.o'));
    args.add('-m32', test: _bits == 32);
    args.add('-m64', test: _bits == 64);
    args.addAll(_linkerLibpath, prefix: '-L');
  }

  void _setupArgumentsOnLinux() {
    // Compiler
    _setupArgumentsForPosixCompiler();
    // Linker
    _setupArgumentsForPosixLinker();
    var args = _linkerArgs;
    args.add('-shared');
    args.add('-o');
    args.add(_linkerOutput, prefix: 'lib', suffix: '.so');
  }

  void _setupArgumentsOnMacOS() {
    // Compiler
    _setupArgumentsForPosixCompiler();
    // Linker
    _setupArgumentsForPosixLinker();
    var args = _linkerArgs;
    args.add(['-dynamiclib', '-undefined', 'dynamic_lookup']);
    args.add('-o');
    args.add(_linkerOutput, prefix: 'lib', suffix: '.dylib');
  }

  void _setupArgumentsOnWindows() {
    // Compiler
    var args = _compilerArgs;
    args.add('/c');
    args.addAll(_compilerInput);
    args.add('sample_extension_dllmain_win.cc');
    args.addAll(_compilerInclude, prefix: '-I');
    args.addKeys(_compilerDefine, prefix: '-D');
    args.addKey('DART_SHARED_LIB', null, prefix: '-D');
    // Linker
    args = _linkerArgs;
    args.add('/DLL');
    args.addAll(_linkerInput);
    args.addAll(['dart.lib', 'sample_extension_dllmain_win']);
    args.addAll(_linkerLibpath, prefix: '/LIBPATH:');
    args.add('$DART_SDK/bin', prefix: '/LIBPATH:');
    args.add('sample_extension.dll', prefix: '/OUT:');
  }

  int run() {
    _setup();
    return _build();
  }

  void _setup() {
    _operatingSystem = Platform.operatingSystem;
    _bits = DartSDK.getVmBits();
    _setupArguments();
    _setupTools();
  }

  void _setupArguments() {
    _compilerArgs = new CommandLineArguments();
    _linkerArgs = new CommandLineArguments();
    switch(_operatingSystem) {
      case 'linux':
        _setupArgumentsOnLinux();
        break;
      case 'macos':
        _setupArgumentsOnMacOS();
        break;
      case 'windows':
        _setupArgumentsOnWindows();
        break;
      default:
        _errorUnsupportedOperatingSystem();
    }
  }

  void _setupTools() {
    switch(_operatingSystem) {
      case 'android':
      case 'macos':
      case 'linux':
        _compiler = new Gpp();
        _linker = new Gcc();
        break;
      case 'windows':
        _compiler = new Msvc(bits: _bits);
        _linker = new Mslink(bits: _bits);
        break;
      default:
        _errorUnsupportedOperatingSystem();
    }
  }

  List<String> _addExtension(List<String> files, String extension) {
    var length = files.length;
    var result = new List<String>(length);
    for(var i = 0; i < length; i++) {
      var file = files[i];
      if(file.indexOf('.') == -1) {
        result[i] = '$file$extension';
      } else {
        result[i] = file;
      }
    }

    return result;
  }

  List<String> _quote(List<String> list, {String quote: '"'}) {
    var length = list.length;
    var result = new List<String>(length);
    for(var i = 0; i < length; i++) {
      result[i] = '$quote${list[i]}$quote';
    }

    return result;
  }

  void _errorUnsupportedOperatingSystem() {
    throw new StateError('Unsupported operating system $_operatingSystem');
  }
}
