import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constant/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../model/event_model.dart';
import 'event_isolate.dart';

class EventsService {
  final ApiClient _apiClient;

  EventsService(this._apiClient);

  Future<List<TabListRes>> getPublicEvents({
    String? keyword,
    bool? trending,
    int? size,
    int? page,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;
      if (trending != null) queryParams['trending'] = trending;
      if (size != null) queryParams['size'] = size;
      if (page != null) queryParams['page'] = page;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;

      final response = await _apiClient.get(
        ApiEndpoints.publicEvents,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        String jsonString;
        if (response.data is String) {
          jsonString = response.data;
        } else {
          jsonString = json.encode(response.data);
        }

        return await parseTabListInBackground(jsonString);
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}