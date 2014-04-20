part of ccompilers.ccompilers;

class CommandLineArguments {
  List<String> arguments = new List<String>();

  void add(String value, {String prefix, String suffix, bool test: true}) {
    if (test == true) {
      if (prefix == null) {
        prefix = '';
      }

      if (suffix == null) {
        suffix = '';
      }

      value = '$prefix$value$suffix';
      arguments.add(value);
    }
  }

  void addAll(List<String> arguments, {String prefix, String suffix, bool test:
      true}) {
    if (test == true) {
      for (var argument in arguments) {
        add(argument, prefix: prefix, suffix: suffix);
      }
    }
  }

  void addKey(String key, String value, {String prefix, String suffix, String
      separator: '=', bool test: true}) {
    if (test == true) {
      if (value == null) {
        add(key, prefix: prefix, suffix: suffix);
      } else {
        add('$key$separator$value', prefix: prefix, suffix: suffix);
      }
    }
  }

  void addKeys(Map map, {String prefix, String suffix, bool test: true}) {
    if (test == true) {
      for (var key in map.keys) {
        var value = map[key];
        addKey(key, value, prefix: prefix, suffix: suffix);
      }
    }
  }

  void clear() {
    arguments.clear();
  }

  String toString() {
    return arguments.join(' ');
  }
}
