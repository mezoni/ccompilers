part of ccompilers.ccompilers;

/**
 * Command line arguments wrapper.
 */
class CommandLineArguments {
  List<String> arguments = new List<String>();

  /**
   * Adds the [value] to the [arguments].
   *
   * Parameters:
   *  [test]
   *    If true adds the specified value to the argument lists; otherwise
   *    value will not be added.
   *  [prefix]
   *    The prefix that will be added before the value.
   *  [suffix]
   *    The suffix that will be added after the value.
   */
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

  /**
   * Adds the [values] to the [arguments].
   *
   * Parameters:
   *  [test]
   *    If true adds the specified values to the argument lists; otherwise
   *    values will not be added.
   *  [prefix]
   *    The prefix that will be added before the each value.
   *  [suffix]
   *    The suffix that will be added after the each value.
   */
  void addAll(List<String> values,
      {String prefix, String suffix, bool test: true}) {
    if (test == true) {
      for (var argument in values) {
        add(argument, prefix: prefix, suffix: suffix);
      }
    }
  }

  /**
   * Adds the [key] and the [value] to the [arguments].
   *
   * Parameters:
   *  [test]
   *    If true adds the specified key/value to the argument lists; otherwise
   *    key/value will not be added.
   *  [prefix]
   *    The prefix that will be added before the each key/value.
   *  [suffix]
   *    The suffix that will be added after the each key/value.
   *  [separator]
   *    The separator that will separate the key from the value.
   */
  void addKey(String key, String value,
      {String prefix, String suffix, String separator: '=', bool test: true}) {
    if (test == true) {
      if (value == null) {
        add(key, prefix: prefix, suffix: suffix);
      } else {
        add('$key$separator$value', prefix: prefix, suffix: suffix);
      }
    }
  }

  /**
   * Adds the [keys] and the [values] to the [arguments].
   *
   * Parameters:
   *  [test]
   *    If true adds the specified keys/values to the argument lists; otherwise
   *    keys/values will not be added.
   *  [prefix]
   *    The prefix that will be added before the each key/value.
   *  [suffix]
   *    The suffix that will be added after the each key/value.
   *  [separator]
   *    The separator that will separate the key from the value.
   */
  void addKeys(Map<String, String> map,
      {String prefix, String suffix, bool test: true}) {
    if (test == true) {
      for (var key in map.keys) {
        var value = map[key];
        addKey(key, value, prefix: prefix, suffix: suffix);
      }
    }
  }

  /**
   * Clears the argument list.
   */
  void clear() {
    arguments.clear();
  }

  /**
   * Returns the copy of this object.
   */
  CommandLineArguments copy() {
    var copy = new CommandLineArguments();
    copy.arguments.addAll(arguments);
    return copy;
  }

  /**
   * Returns the string representation.
   */
  String toString() {
    return arguments.join(' ');
  }
}
