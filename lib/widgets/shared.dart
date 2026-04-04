import 'package:flutter/material.dart';

const Color bg = Color(0xFF070300);
const Color gold = Color(0xFFFFB800);
const Color border = Color(0xFF3A2500);

bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

Color themeBg(BuildContext context) =>
    isDark(context) ? bg : const Color(0xFFFBFBFB);

Color themeBorder(BuildContext context) =>
    isDark(context) ? border : Colors.grey[300]!;

Color themeSurface(BuildContext context) =>
    isDark(context) ? const Color(0xFF090501) : Colors.white;

Color themeSection(BuildContext context) =>
    isDark(context) ? const Color(0xFF0C0704) : const Color(0xFFF2F2F2);

Color themeText(BuildContext context) =>
    isDark(context) ? Colors.white : const Color(0xFF1A1A1A);

Color themeTextDim(BuildContext context) =>
    isDark(context) ? Colors.white54 : const Color(0xFF666666);

class VerticalAccentLine extends StatelessWidget {
  const VerticalAccentLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: themeBorder(context),
    );
  }
}
