import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gowagr/views/cubit/event_cubit.dart';
import 'package:gowagr/views/pages/home.dart';
import 'core/constant/app_colors.dart';
import 'core/network/api_client.dart';
import 'data/repo/event_repo.dart';
import 'data/services/event_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
          create: (context) => ApiClient(),
        ),
        RepositoryProvider<EventsService>(
          create: (context) => EventsService(context.read<ApiClient>()),
        ),
        RepositoryProvider<EventsRepository>(
          create: (context) => EventsRepository(context.read<EventsService>()),
        ),
      ],
      child: BlocProvider(
        create: (context) => EventsCubit(context.read<EventsRepository>()),
        child: MaterialApp(
          title: 'Gowagr Events',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            cardTheme: CardThemeData(
              color: AppColors.surface,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: AppColors.text),
              bodyMedium: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}