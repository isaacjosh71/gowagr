import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _eventsKey = 'cached_events';
  static const String _lastFetchKey = 'last_fetch_time';
  static const Duration _cacheExpiry = Duration(minutes: 30);

  static Future<void> cacheEvents(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_eventsKey, data);
    await prefs.setInt(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getCachedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetch = prefs.getInt(_lastFetchKey);

    if (lastFetch == null) return null;

    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    final now = DateTime.now();

    if (now.difference(lastFetchTime) > _cacheExpiry) {
      await clearCache();
      return null;
    }

    return prefs.getString(_eventsKey);
  }

  static Future<bool> hasCachedData() async {
    final cachedData = await getCachedEvents();
    return cachedData != null;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
    await prefs.remove(_lastFetchKey);
  }
}