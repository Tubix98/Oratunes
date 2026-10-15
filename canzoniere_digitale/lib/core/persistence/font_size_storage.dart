import 'package:shared_preferences/shared_preferences.dart';
import '../layout/font_size_level.dart';

class FontSizeStorage {
  static const _key = 'font_size_level';

  static Future<void> save(FontSizeLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, level.name);
  }

  static Future<FontSizeLevel> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    switch (value) {
      case 'small':
        return FontSizeLevel.small;
      case 'large':
        return FontSizeLevel.large;
      case 'medium':
      default:
        return FontSizeLevel.medium;
    }
  }
}