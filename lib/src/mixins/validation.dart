abstract class Validation {
  // This class is intended to be used as a mixin, and should not be
  // extended directly.
  factory Validation._() => null;

  String email(String v) {
    if (v.isEmpty) {
      return 'Please enter some text';
    }

    if (!v.contains('@') || !v.contains('.')) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String notEmpty(String v) {
    if (v.isEmpty) {
      return 'Please enter some text';
    }

    return null;
  }

  String Function(String) min(int length) {
    return (String v) {
      if (v.length < length) return 'Needs to be at least $length characters';

      return null;
    };
  }

  String Function(String) multiple(List<String Function(String)> f) {
    return (String v) {
      String r;
      f.forEach((element) {
        r = element(v);
        if (r != null) return;
      });
      return r;
    };
  }
}
