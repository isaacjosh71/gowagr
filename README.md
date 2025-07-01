# gowagr

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

lib/
├── core/
│   ├── constants/        # App-wide constants (colors, strings, API endpoints)
│   ├── network/          # API client and networking setup
│   ├── storage/          # Cache management
│
│
├── data/
│   ├── model/            # Data models (DTOs)
│   ├── repo/             # Repository implementations
│   ├── services/         # API service classes
│   └── isolates/         # Isolates for heavy computation
│
├── presentation/
│   ├── cubit/            # Business logic (BLoC/Cubit and State classes)
│   ├── pages/            # Screen widgets
│   ├── widgets/          # Reusable UI components
│
│
└── main.dart             # App entry point



State Management Approach
BLoC/Cubit Pattern
Why chosen: For its simplicity compared to full BLoC while maintaining good separation of concerns

Implementation:

EventsCubit manages all event-related state

States include: Initial, Loading, Loaded, Error, Empty

Handles pagination, searching, and filtering

Provides refresh capability

State Flow
UI triggers event (load, search, filter)

Cubit processes event and emits new state

UI rebuilds based on new state


Caching Implementation
Storage: used SharedPreferences and raw event JSON data

Expiration: 30 minutes

Key Features:
Two-layer caching:

Memory cache in Cubit (_allEvents)

Smart refresh:

Uses cached data while fetching fresh data

Only shows cached data if fresh fetch fails

Clear indication when showing cached data


Key Decisions & Trade-offs
1. JSON Parsing in Isolate

Decision: Used isolates for JSON parsing to prevent UI jank with large datasets

Trade-off: Added complexity to codebase

2. Caching Strategy

Decision: Cached raw JSON instead of parsed objects  for faster read/write operations

Trade-off: Requires re-parsing on each load

3. Pagination Approach

Decision: Client-side pagination management to utilize more control over loading states

Trade-off: Requires maintaining page state in Cubit

Error Handling

Decision: Graceful degradation to cached data for better user experience during network issues

Trade-off: Potential stale data display
