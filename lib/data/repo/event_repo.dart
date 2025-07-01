import '../../core/storage/cache_manager.dart';
import '../model/event_model.dart';
import '../services/event_service.dart';

class EventsRepository {
  final EventsService _eventsService;

  EventsRepository(this._eventsService);

  Future<List<TabListRes>> getEvents({
    String? keyword,
    bool? trending,
    int? size,
    int? page,
    String? category,
    bool forceRefresh = false,
  }) async {
    final shouldFetchFresh = forceRefresh ||
        keyword != null ||
        category != null ||
        trending == true ||
        (page != null && page > 1);

    if (!shouldFetchFresh) {
      final cachedData = await CacheManager.getCachedEvents();
      if (cachedData != null) {
        try {
          return tabListResFromJson(cachedData);
        } catch (e) {
          await CacheManager.clearCache();
        }
      }
    }

    try {
      final events = await _eventsService.getPublicEvents(
        keyword: keyword,
        trending: trending,
        size: size,
        page: page,
        category: category,
      );

      if ((page == null || page == 1) &&
          keyword == null &&
          category == null &&
          trending != true) {
        final jsonString = tabListResToJson(events);
        await CacheManager.cacheEvents(jsonString);
      }

      return events;
    } catch (e) {
      if (!shouldFetchFresh) {
        final cachedData = await CacheManager.getCachedEvents();
        if (cachedData != null) {
          try {
            return tabListResFromJson(cachedData);
          } catch (_) {}
        }
      }
      rethrow;
    }
  }

  Future<bool> hasCachedData() async {
    return await CacheManager.hasCachedData();
  }

  Future<void> clearCache() async {
    await CacheManager.clearCache();
  }
}