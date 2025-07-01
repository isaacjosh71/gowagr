import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/event_model.dart';
import '../../data/repo/event_repo.dart';
import 'event_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _repository;

  static const int _pageSize = 20;
  int _currentPage = 1;
  List<TabListRes> _allEvents = [];
  String? _currentKeyword;
  String? _currentCategory;
  bool _isShowingTrending = false;

  EventsCubit(this._repository) : super(EventsInitial());

  Future<void> loadEvents({bool forceRefresh = false}) async {
    if (state is EventsLoading) return;

    emit(EventsLoading());

    try {
      final events = await _repository.getEvents(
        page: 1,
        size: _pageSize,
        forceRefresh: forceRefresh,
      );

      _allEvents = events;
      _currentPage = 1;
      _currentKeyword = null;
      _currentCategory = null;
      _isShowingTrending = false;

      if (events.isEmpty) {
        emit(const EventsEmpty('No events available'));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.length < _pageSize,
          isFromCache: !forceRefresh && await _repository.hasCachedData(),
        ));
      }
    } catch (e) {
      final hasCache = await _repository.hasCachedData();
      if (hasCache && !forceRefresh) {
        try {
          final cachedEvents = await _repository.getEvents();
          _allEvents = cachedEvents;
          emit(EventsLoaded(
            events: cachedEvents,
            isFromCache: true,
          ));
        } catch (_) {
          emit(EventsError(e.toString()));
        }
      } else {
        emit(EventsError(e.toString()));
      }
    }
  }

  Future<void> loadMoreEvents() async {
    final currentState = state;
    if (currentState is! EventsLoaded || currentState.hasReachedMax) return;

    emit(EventsLoadingMore(currentState.events));

    try {
      final newEvents = await _repository.getEvents(
        page: _currentPage + 1,
        size: _pageSize,
        keyword: _currentKeyword,
        category: _currentCategory,
        trending: _isShowingTrending ? true : null,
      );

      _currentPage++;
      _allEvents.addAll(newEvents);

      emit(EventsLoaded(
        events: List.from(_allEvents),
        hasReachedMax: newEvents.length < _pageSize,
        currentKeyword: _currentKeyword,
        currentCategory: _currentCategory,
        isShowingTrending: _isShowingTrending,
      ));
    } catch (e) {
      emit(EventsLoaded(
        events: currentState.events,
        hasReachedMax: currentState.hasReachedMax,
        currentKeyword: _currentKeyword,
        currentCategory: _currentCategory,
        isShowingTrending: _isShowingTrending,
      ));
    }
  }

  Future<void> searchEvents(String keyword) async {
    if (_currentKeyword == keyword) return;

    emit(EventsLoading());

    try {
      final events = await _repository.getEvents(
        keyword: keyword.isEmpty ? null : keyword,
        category: _currentCategory,
        page: 1,
        size: _pageSize,
        forceRefresh: true,
      );

      _allEvents = events;
      _currentPage = 1;
      _currentKeyword = keyword.isEmpty ? null : keyword;

      if (events.isEmpty) {
        emit(EventsEmpty(keyword.isEmpty
            ? 'No events available'
            : 'No events found for "$keyword"'));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.length < _pageSize,
          currentKeyword: _currentKeyword,
          currentCategory: _currentCategory,
          isShowingTrending: _isShowingTrending,
        ));
      }
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> filterByCategory(String? category) async {
    if (_currentCategory == category) return;

    emit(EventsLoading());

    try {
      final events = await _repository.getEvents(
        keyword: _currentKeyword,
        category: category,
        page: 1,
        size: _pageSize,
        forceRefresh: true,
      );

      _allEvents = events;
      _currentPage = 1;
      _currentCategory = category;

      if (events.isEmpty) {
        emit(EventsEmpty(category == null
            ? 'No events available'
            : 'No events found in "$category" category'));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.length < _pageSize,
          currentKeyword: _currentKeyword,
          currentCategory: _currentCategory,
          isShowingTrending: _isShowingTrending,
        ));
      }
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> loadTrendingEvents() async {
    if (_isShowingTrending) return;

    emit(EventsLoading());

    try {
      final events = await _repository.getEvents(
        trending: true,
        page: 1,
        size: _pageSize,
        forceRefresh: true,
      );

      _allEvents = events;
      _currentPage = 1;
      _currentKeyword = null;
      _currentCategory = null;
      _isShowingTrending = true;

      if (events.isEmpty) {
        emit(const EventsEmpty('No trending events available'));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.length < _pageSize,
          isShowingTrending: true,
        ));
      }
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  void refresh() {
    loadEvents(forceRefresh: true);
  }
}