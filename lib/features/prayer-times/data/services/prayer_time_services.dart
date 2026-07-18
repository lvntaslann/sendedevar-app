import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/prayer_time_model.dart';

class PrayerTimeService {
  final String baseUrl;

  PrayerTimeService({required this.baseUrl});

  Future<PrayerTimesResponse> fetchPrayerTimes({
    required double lat,
    required double lng,
    required String date,
    int method = 13, // Turkey
  }) async {
    /// Eğer baseUrl = https://api.aladhan.com/v1
    final url =
        "$baseUrl/timings/$date?latitude=$lat&longitude=$lng&method=$method";

    print("API URL: $url");

    final response = await http.get(Uri.parse(url));

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return PrayerTimesResponse.fromJson(body);
    } else {
      throw Exception("API HATA: ${response.statusCode} - ${response.body}");
    }
  }
}
