import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constant/app_colors.dart';
import '../cubit/event_cubit.dart';
import '../cubit/event_state.dart';
import '../widgets/event_card.dart';
import '../widgets/filter.dart';
import '../widgets/loading_state.dart';
import '../widgets/search_bar.dart';

class QallaTab extends StatefulWidget {
  const QallaTab({super.key});

  @override
  State<QallaTab> createState() => _QallaTabState();
}

class _QallaTabState extends State<QallaTab> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<EventsCubit>().loadEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<EventsCubit>().loadMoreEvents();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<EventsCubit>().refresh();
        },
        color: AppColors.primary,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    onSearch: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                      context.read<EventsCubit>().searchEvents(query);
                    },
                    initialValue: _searchQuery,
                    onClear: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _searchQuery = '';
                      });
                      context.read<EventsCubit>().searchEvents('');
                    },
                  ),

                  SizedBox(height: 16),

                  BlocBuilder<EventsCubit, EventsState>(
                    builder: (context, state) {
                      String? selectedCategory;
                      bool isShowingTrending = false;

                      if (state is EventsLoaded) {
                        selectedCategory = state.currentCategory;
                        isShowingTrending = state.isShowingTrending;
                      }

                      return CategoryFilter(
                        selectedCategory: selectedCategory,
                        isShowingTrending: isShowingTrending,
                        onCategorySelected: (category) {
                          context.read<EventsCubit>().filterByCategory(category);
                        },
                        onTrendingTap: () {
                          context.read<EventsCubit>().loadTrendingEvents();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<EventsCubit, EventsState>(
                builder: (context, state) {
                  if (state is EventsLoading) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      itemBuilder: (context, index) => EventCardShimmer(),
                    );
                  }

                  if (state is EventsError && state.cachedEvents == null) {
                    return ErrorState(
                      message: state.message,
                      onRetry: () => context.read<EventsCubit>().refresh(),
                    );
                  }

                  if (state is EventsEmpty) {
                    return EmptyState(
                      message: state.message,
                      icon: Icons.search_off,
                      onRetry: () => context.read<EventsCubit>().refresh(),
                    );
                  }

                  if (state is EventsLoaded || state is EventsLoadingMore) {
                    final events = state is EventsLoaded
                        ? state.events
                        : (state as EventsLoadingMore).currentEvents;

                    final isFromCache = state is EventsLoaded && state.isFromCache;
                    final isLoadingMore = state is EventsLoadingMore;

                    return Column(
                      children: [
                        if (isFromCache)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            color: Colors.orange.withOpacity(0.1),
                            child: Text(
                              '📱 Showing cached data - Pull to refresh',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            controller: _scrollController,
                            itemCount: events.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= events.length) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  child: LoadingIndicator(),
                                );
                              }

                              return EventCard(event: events[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}