import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';

// Only a collection of themes
// Used for ColorModeNotifier to set the app theme dynamically
class Themes {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  Themes(this.lightTheme, this.darkTheme);

  static Themes getNewTheme(Color seedColor) {
    // The basic theme, global theme data changes should be put here.
    ThemeData basicTheme(Brightness brightness) {
      return ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: brightness
        ),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      );
    }

    return Themes(
      basicTheme(Brightness.light),
      basicTheme(Brightness.dark),
    );
  }

  static final Map<String, Themes> flutterColorThemes = {
    "pink": getNewTheme(Colors.pink),
    "rot": getNewTheme(Colors.red),
    "dunkelorange": getNewTheme(Colors.deepOrange),
    "orange": getNewTheme(Colors.orange),
    "gelb": getNewTheme(Colors.yellow),
    "lindgrün": getNewTheme(Colors.lime),
    "hellgrün": getNewTheme(Colors.lightGreen),
    "grün": getNewTheme(Colors.green),
    "seegrün": getNewTheme(Colors.teal),
    "türkis": getNewTheme(Colors.cyan),
    "hellblau": getNewTheme(Colors.lightBlue),
    "blau": getNewTheme(Colors.blue),
    "indigoblau": getNewTheme(Colors.indigo),
    "lila": getNewTheme(Colors.purple),
    "braun": getNewTheme(Colors.brown[900]!),
  };

  // Will be later set by DynamicColorBuilder in main.dart App().
  static Themes dynamicTheme = Themes(null, null);

  // Will be set by ColorModeNotifier.init() or _getSchoolTheme() in client.dart.
  static Themes schoolTheme = Themes(null, null);
  
  static Themes standardTheme = getNewTheme(Colors.deepPurple);
}

class ColorModeNotifier {
  static ValueNotifier<Themes> notifier = ValueNotifier<Themes>(Themes.standardTheme);

  static void set(String name, Themes theme) async {
    await globalStorage.write(key: "color", value: name);
    notifier.value = theme;
  }

  static void init() async {
    // TODO: Change "color" key and others keys to enums or so, we can't just use magic strings forever.
    String colorTheme = await globalStorage.read(key: "color") ?? "standard";

    if (await globalStorage.read(key: "schoolColor") != null) {
      int schoolColor = int.parse((await globalStorage.read(key: "schoolColor"))!);

      Themes.schoolTheme = Themes.getNewTheme(Color(schoolColor));
    }

    if (colorTheme == "standard") {
      set("standard", Themes.standardTheme);
    } else if (colorTheme == "school") {
      set("school", Themes.schoolTheme);
    } else if (colorTheme != "dynamic") {
      set(colorTheme, Themes.flutterColorThemes[colorTheme]!);
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