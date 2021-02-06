import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';

const String _tutorialPrefs = 'tutorial.';

class SharedPrefsTutorialDatabase extends TutorialDatabase<SharedPreferences> {
  @override
  Future<SharedPreferences> open() => SharedPreferences.getInstance();

  @override
  Future<Iterable<String>> loadKeys() async {
    final prefs = await data;
    return prefs
        .getKeys()
        .where((key) => key.startsWith(_tutorialPrefs))
        .map((key) => key.substring(_tutorialPrefs.length));
  }

  @override
  Future<bool> load(String key) async {
    final p = '$_tutorialPrefs$key';
    final prefs = await data;
    if (prefs.containsKey(p)) {
      return prefs.getBool(p);
    } else {
      return null;
    }
  }

  @override
  Future<void> save(String key, bool value) async {
    final p = '$_tutorialPrefs$key';
    final prefs = await data;
    await prefs.setBool(p, value);
  }

  @override
  Future<bool> delete(String key) async {
    final p = '$_tutorialPrefs$key';
    final prefs = await data;
    return prefs.remove(p);
  }
}
