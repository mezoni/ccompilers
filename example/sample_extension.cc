#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef _WIN32
#include "windows.h"
#else
#include <stdbool.h>
#include <dlfcn.h>
#include <unistd.h>
#include <sys/mman.h>
#endif

#include "dart_api.h"

Dart_NativeFunction ResolveName(Dart_Handle name, int argc);

DART_EXPORT Dart_Handle sample_extension_Init(Dart_Handle parent_library) {
  if (Dart_IsError(parent_library)) { return parent_library; }

  Dart_Handle result_code = Dart_SetNativeResolver(parent_library, ResolveName);
  if (Dart_IsError(result_code)) return result_code;

  return Dart_Null();
}

Dart_Handle HandleError(Dart_Handle handle) {
  if (Dart_IsError(handle)) Dart_PropagateError(handle);
  return handle;
}

void GetPageSize(Dart_NativeArguments arguments) {
  Dart_Handle result;
#if _WIN32
  SYSTEM_INFO si;
#endif

  Dart_EnterScope();
#if _WIN32
  GetSystemInfo(&si);
  result = Dart_NewInteger(si.dwPageSize);
#else
  result = Dart_NewInteger(sysconf(_SC_PAGESIZE));
#endif
  Dart_SetReturnValue(arguments, result);
  Dart_ExitScope();
}

void GetVersionString(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  Dart_Handle result = Dart_NewStringFromCString(Dart_VersionString());
  Dart_SetReturnValue(arguments, result);
  Dart_ExitScope();
}

void GetSizeOfInt(Dart_NativeArguments arguments) {
  Dart_Handle result;

  Dart_EnterScope();
  result = Dart_NewInteger(sizeof(int));
  Dart_SetReturnValue(arguments, result);
  Dart_ExitScope();
}

void IsLittleEndian(Dart_NativeArguments arguments) {
  uint8_t* bytes;
  uint16_t word = 1;
  Dart_Handle result;

  Dart_EnterScope();
  bytes = (uint8_t*)&word;
  result = Dart_NewBoolean((bool)*bytes);
  Dart_SetReturnValue(arguments, result);
  Dart_ExitScope();
}

struct FunctionLookup {
  const char* name;
  Dart_NativeFunction function;
};

FunctionLookup function_list[] = {
  {"GetPageSize", GetPageSize},
  {"GetSizeOfInt", GetSizeOfInt},
  {"GetVersionString", GetVersionString},
  {"IsLittleEndian", IsLittleEndian},
  {NULL, NULL}};

Dart_NativeFunction ResolveName(Dart_Handle name, int argc) {
  if (!Dart_IsString(name)) return NULL;
  Dart_NativeFunction result = NULL;
  Dart_EnterScope();
  const char* cname;
  HandleError(Dart_StringToCString(name, &cname));

  for (int i=0; function_list[i].name != NULL; ++i) {
    if (strcmp(function_list[i].name, cname) == 0) {
      result = function_list[i].function;
      break;
    }
  }
  Dart_ExitScope();
  return result;
}
