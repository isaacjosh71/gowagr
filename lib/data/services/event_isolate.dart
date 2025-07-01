import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gowagr/data/model/event_model.dart';

Future<List<TabListRes>> parseTabListInBackground(String responseBody) async {
  return await compute(parseTabList, responseBody);
}

List<TabListRes> parseTabList(String responseBody) {
  try {
    final jsonData = json.decode(responseBody);

    if (jsonData is Map<String, dynamic> && jsonData.containsKey('events')) {
      final apiResponse = ApiResponse.fromJson(jsonData);
      return apiResponse.events;
    } else if (jsonData is List) {
      return List<TabListRes>.from(jsonData.map((x) => TabListRes.fromJson(x)));
    } else {
      if (kDebugMode) {
        print('Unexpected JSON structure: $jsonData');
      }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error parsing TabListRes: $e');
      print('Response body preview: ${responseBody.length > 500 ? "${responseBody.substring(0, 500)}..." : responseBody}');
    }
    return [];
  }
}