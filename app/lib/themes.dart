import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';

// The basic theme, global theme data changes should be put here.
ThemeData getThemeData(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}

// Used for ColorModeNotifier to set the app theme dynamically
class Themes {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  Themes(this.lightTheme, this.darkTheme);

  static final Map<String, Themes> map = {
    "standard": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark)),
    ),
    "pink": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.pink)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.pink, brightness: Brightness.dark)),
    ),
    "rot": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.red)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark)),
    ),
    "dunkelorange": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.dark)),
    ),
    "orange": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.orange)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark)),
    ),
    "gelb": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.yellow)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.yellow, brightness: Brightness.dark)),
    ),
    "lindgrün": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.lime)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.lime, brightness: Brightness.dark)),
    ),
    "hellgrün": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.lightGreen)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.lightGreen, brightness: Brightness.dark)),
    ),
    "grün": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.green)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark)),
    ),
    "seegrün": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.teal)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark)),
    ),
    "türkis": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.cyan)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark)),
    ),
    "hellblau": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark)),
    ),
    "blau": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.blue)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
    ),
    "indigoblau": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.indigo)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark)),
    ),
    "lila": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.purple)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.purple, brightness: Brightness.dark)),
    ),
    "braun": Themes(
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.brown[900]!)),
      getThemeData(ColorScheme.fromSeed(seedColor: Colors.brown[900]!, brightness: Brightness.dark)),
    ),
  };

  static Themes dynamicTheme = Themes(null, null); // Will be later set by DynamicColorBuilder in main.dart App()
}

class ColorModeNotifier {
  static ValueNotifier<Themes> notifier = ValueNotifier<Themes>(Themes.map["standard"]!);

  static void set(String colorTheme) async {
    await globalStorage.write(key: "color", value: colorTheme);
    notifier.value = Themes.map[colorTheme]!;
  }

  static void setDynamic() async {
    await globalStorage.write(key: "color", value: "dynamic");
    notifier.value = Themes.dynamicTheme;
  }

  static void init() async {
    String colorTheme = await globalStorage.read(key: "color") ?? "standard";
    if (colorTheme != "dynamic") {
      notifier.value = Themes.map[colorTheme]!;
      // Dynamic theme will be set later by DynamicColorBuilder, bc we don't get the dynamic theme on startup.
    }
  }
}

// For setting the themeMode of MaterialApp dynamically
class ThemeModeNotifier {
  static ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  static void _notify(String theme) {
    if (theme == "dark") {
      notifier.value = ThemeMode.dark;
    } else if (theme == "light") {
      notifier.value = ThemeMode.light;
    } else {
      notifier.value = ThemeMode.system;
    }
  }

  static void init() async {
    String theme = await globalStorage.read(key: "theme") ?? "system";
    _notify(theme);
  }

  static void set(String theme) async {
    await globalStorage.write(key: "theme", value: theme);
    _notify(theme);
  }
}