/// An extension on Map<Object?, Object?> to provide a method for converting
/// its entries to a Map<String, String>.
extension MapResponseConvertExtension on Map<Object?, Object?> {
  /// Converts the map's entries to a new map with String keys and values.
  ///
  /// This method iterates over each entry in the original map and creates
  /// a new map with string representations of the keys and values.
  ///
  /// Returns:
  /// - A new Map<String, String> containing the converted entries.
  Map<String, String> toStringMap() {
    // Create an empty map to hold the state values.
    final stateMap = <String, String>{};

    // Iterate over each entry in the original map.
    for (final entry in entries) {
      // Convert the key and value to strings and add them to the new map.
      stateMap[entry.key.toString()] = entry.value.toString();
    }

    // Return the newly created map.
    return stateMap;
  }
}
