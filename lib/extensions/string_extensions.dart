import 'dart:core';

extension StringExtensions on String {
  String replaceAt(int index, String char) {
    assert(index >= 0);
    assert(index < length);
    return substring(0, index) + char + substring(index + 1);
  }
}
