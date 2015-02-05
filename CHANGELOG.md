## 0.2.9

- Added the possibility passing arguments `environment` and `workingDirectory` for the compilers and linkers

## 0.2.8

- The order of the arguments was modified. The user defined arguments goes now last

## 0.2.7

- Improved the detection of 'DART_SDK' location

## 0.2.6

- Corrected the detection of 'DART_SDK' but it is still not fully functional when using multiple Dart SDK

## 0.2.5

- Fixed bug in 'MsvcUtils'

## 0.2.4

- Improved detection of MS Visual Studio C/C++ Compiler

## 0.2.3

- Fixed bug in 'MsLinker'

## 0.2.2

- `DartSDK.getVmBits()` now uses information from `SysInfo.userSpaceBitness`

## 0.2.1

- Changed constructor in `GnuLinker`, added parameter `bits`
- Changed constructor in `MsLinker`, added parameter `bits`

## 0.2.0

- Added class `GnuCCompiler`
- Added class `GnuCppCompiler`
- Added class `GnuLinker`
- Added class `MsCCompiler`
- Added class `MsCppCompiler`
- Added class `MsLinker`
- Added interface `CompilerTool`
- Added interface `LinkerTool`

