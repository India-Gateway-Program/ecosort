import 'dart:ui';

enum Recyclability {
  recyclable(
    "Good",
    Color(0xFF4CAF50),
  ),
  nonRecyclable(
    "Bad",
    Color(0xFFF44336),
  ),
  unknown(
    "Unknown",
    Color(0xFF9E9E9E),
  );

  final String title;
  final Color color;

  const Recyclability(this.title, this.color);

  @override
  String toString() => title;
}
