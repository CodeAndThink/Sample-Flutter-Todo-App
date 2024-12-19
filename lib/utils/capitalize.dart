/// An extension on String to capitalize the first character of the string.
extension StringExtension on String {
  String get capitalized {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}