import 'package:flutter/cupertino.dart';

/// An extension on the String class to add functionality for converting
/// a string representation of a duration into a Duration object.
extension DurationConversionExtension on String {
  /// Converts the string representation of a duration to a Duration object.
  ///
  /// The input string should represent a numeric value, which can be
  /// parsed into a double. The value is then treated as seconds.
  ///
  /// Returns:
  /// - A Duration object representing the parsed seconds.
  /// - Returns null if the string is empty or cannot be parsed.
  Duration? toDuration() {
    if (isEmpty) {
      /// Return null for empty strings
      return null;
    }

    try {
      /// Parse the string to a double and convert it to seconds
      return Duration(seconds: (double.parse(this)).floor());
    } catch (e) {
      /// Handle any parsing exceptions, log if needed
      debugPrint('Error parsing duration from string: $this, error: $e');
      /// Return null if the parsing fails
      return null;
    }
  }
}
