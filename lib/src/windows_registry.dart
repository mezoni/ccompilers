part of ccompilers.ccompilers;

class WindowsRegistry {
  static String query(String keyName, List<String> arguments) {
    var result = Process.runSync('reg query "$keyName"', arguments);
    if (result.exitCode != 0) {
      return null;
    }

    var regVersion = '\r\n! REG.EXE VERSION ';
    var str = result.stdout as String;
    if (str.startsWith(regVersion)) {
      str = str.substring(regVersion.length + 7);
    } else {
      str = str.substring(2);
    }

    return str;
  }

  static WindowsRegistryKey queryAllKeys(String keyName) {
    var result = query(keyName, ['/s']);
    if (result == null) {
      return null;
    }

    return _parseQuerySubkeys(keyName, result);
  }

  static WindowsRegistryKey _parseQuerySubkeys(
      String queryKey, String queryResult) {
    var map = new LinkedHashMap<String, WindowsRegistryKey>();
    map[queryKey] = new WindowsRegistryKey(queryKey);
    var strings = queryResult.split('\r\n');
    var count = strings.length;
    var index = 0;
    while (true) {
      if (index >= count) {
        break;
      }

      var fullName = strings[index++];
      if (fullName.isEmpty) {
        break;
      }

      WindowsRegistryKey regKey;
      if (!map.containsKey(fullName)) {
        regKey = new WindowsRegistryKey(fullName);
        map[fullName] = regKey;
      } else {
        regKey = map[fullName];
      }

      WindowsRegistryKey parent;
      var parentName = regKey.parentName;
      if (!map.containsKey(parentName)) {
        parent = new WindowsRegistryKey(parentName);
        map[parentName] = parent;
      } else {
        parent = map[parentName];
      }

      parent.keys[regKey.name] = regKey;
      while (true) {
        if (index >= count) {
          break;
        }

        var string = strings[index++];
        if (string.isEmpty) {
          break;
        }

        var value = new WindowsRegistryValue();
        var exp = new RegExp(r'^\s+(\S+)\s+(\S+)\s+(\S.*)');
        var matches = exp.allMatches(string);
        var iterator = new HasNextIterator(matches.iterator);
        if (iterator.hasNext) {
          var match = iterator.next();
          var name = match[1];
          value.type = match[2];
          value.value = match[3];
          regKey.values[name] = value;
        }
      }
    }

    return map[queryKey];
  }
}

class WindowsRegistryKey {
  final String fullName;

  String _name;

  Map<String, WindowsRegistryKey> keys = {};

  Map<String, WindowsRegistryValue> values = {};

  WindowsRegistryKey(this.fullName) {
    if (fullName == null || fullName.isEmpty || fullName.endsWith('\\')) {
      throw new ArgumentError('fullName: $fullName');
    }

    var index = fullName.lastIndexOf('\\');
    if (index == -1) {
      _name = fullName;
    } else {
      _name = fullName.substring(index + 1);
    }
  }

  String get name => _name;

  String get parentName {
    if (fullName == name) {
      return '';
    }

    return fullName.substring(0, fullName.length - _name.length - 1);
  }

  WindowsRegistryKey operator [](String relativePath) {
    if (relativePath == null) {
      throw new ArgumentError('relativePath: $relativePath');
    }

    if (relativePath.isEmpty) {
      return this;
    }

    var parts = relativePath.split('\\');
    var key = this;
    for (var part in parts) {
      if (key == null) {
        break;
      }

      if (key.keys.containsKey(part)) {
        key = key.keys[part];
        continue;
      }

      break;
    }

    return key;
  }

  String toString() => '$fullName';
}

class WindowsRegistryValue {
  String type;
  String value;

  String toString() => '{$type} $value';
}
