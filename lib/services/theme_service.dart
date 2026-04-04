import 'package:flutter/material.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier(ThemeMode.dark);

  static void setTheme(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
}
