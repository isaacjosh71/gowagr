import 'package:equatable/equatable.dart';
import '../../data/model/event_model.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoadingMore extends EventsState {
  final List<TabListRes> currentEvents;

  const EventsLoadingMore(this.currentEvents);

  @override
  List<Object?> get props => [currentEvents];
}

class EventsLoaded extends EventsState {
  final List<TabListRes> events;
  final bool hasReachedMax;
  final bool isFromCache;
  final String? currentKeyword;
  final String? currentCategory;
  final bool isShowingTrending;

  const EventsLoaded({
    required this.events,
    this.hasReachedMax = false,
    this.isFromCache = false,
    this.currentKeyword,
    this.currentCategory,
    this.isShowingTrending = false,
  });

  EventsLoaded copyWith({
    List<TabListRes>? events,
    bool? hasReachedMax,
    bool? isFromCache,
    String? currentKeyword,
    String? currentCategory,
    bool? isShowingTrending,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFromCache: isFromCache ?? this.isFromCache,
      currentKeyword: currentKeyword ?? this.currentKeyword,
      currentCategory: currentCategory ?? this.currentCategory,
      isShowingTrending: isShowingTrending ?? this.isShowingTrending,
    );
  }

  @override
  List<Object?> get props => [
    events,
    hasReachedMax,
    isFromCache,
    currentKeyword,
    currentCategory,
    isShowingTrending,
  ];
}

class EventsEmpty extends EventsState {
  final String message;

  const EventsEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

class EventsError extends EventsState {
  final String message;
  final bool hasData;
  final List<TabListRes>? cachedEvents;

  const EventsError(
      this.message, {
        this.hasData = false,
        this.cachedEvents,
      });

  @override
  List<Object?> get props => [message, hasData, cachedEvents];
}