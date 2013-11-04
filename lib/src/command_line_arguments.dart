part of ccompilers.ccompilers;

class CommandLineArguments {
  List<String> arguments = new List<String>();

  void add(String value, {String prefix, String quote, String quoteValue, String suffix, bool test: true}) {
    if(test == true) {
      if(quoteValue != null) {
        value = '$quoteValue$value$quoteValue';
      }

      if(prefix == null) {
        prefix = '';
      }

      if(suffix == null) {
        suffix = '';
      }

      value = '$prefix$value$suffix';
      if(quote != null) {
        value = '$quote$value$quote';
      }

      arguments.add(value);
    }
  }

  void addAll(List<String> arguments, {String prefix, String quote, String quoteValue, String suffix, bool test: true}) {
    if(test == true) {
      for(var argument in arguments) {
        add(argument, quote: quote, quoteValue: quoteValue, prefix: prefix, suffix: suffix);
      }
    }
  }

  void addKey(String key, String value, {String prefix, String quote, String quoteValue, String suffix, String separator : '=', bool test: true}) {
    if(test == true) {
      if(value == null) {
        add(key, prefix: prefix, quote: quote, suffix: suffix);
      } else {
        if(quoteValue != null) {
          value = '$quoteValue$value$quoteValue';
        }

        add('$key$separator$value', prefix: prefix, quote: quote, suffix: suffix);
      }
    }
  }

  void addKeys(Map map, {String prefix, String quote, String quoteValue, String suffix, bool test: true}) {
    if(test == true) {
      for(var key in map.keys) {
        var value = map[key];
        addKey(key, value, prefix: prefix, quote: quote, quoteValue: quoteValue, suffix: suffix);
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
