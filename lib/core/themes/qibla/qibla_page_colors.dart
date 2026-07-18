import 'dart:ui';

class QiblaPageColors {
  final bool isDarkMode;

  const QiblaPageColors({required this.isDarkMode});

  Color get pageBgColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFF0C1A12);
  Color get cardBgColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFF1A3E2A);
  Color get dialStrokeColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFF58A47A);
  Color get accentColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFF22C55E);
  Color get needleColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFFE8B84B);
  Color get textColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFFFFFFFF);
  Color get mutedTextColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFFBBC6D0);
}
