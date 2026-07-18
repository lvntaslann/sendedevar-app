import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/prayer_time_model.dart';

class PrayerTimeService {
  final String baseUrl;

  PrayerTimeService({required this.baseUrl});

  Future<PrayerTimesResponse> fetchPrayerTimes({
    required double lat,
    required double lng,
    required String date,
    int method = 13,
  }) async {
    final formattedDate = _toAladhanDate(date);
    final url =
        "$baseUrl/timings/$formattedDate?latitude=$lat&longitude=$lng&method=$method";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Namaz vakitleri alınamadı (HTTP ${response.statusCode})");
    }

    final Map<String, dynamic> body;
    try {
      body = json.decode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception("Namaz vakitleri servisi geçersiz bir yanıt döndürdü");
    }

    final data = body['data'] as Map<String, dynamic>?;
    if (body['code'] != 200 || data == null) {
      throw Exception("Namaz vakitleri servisi geçersiz bir yanıt döndürdü");
    }

    final placeName = await _resolvePlaceName(lat, lng);

    return PrayerTimesResponse.fromAladhan(
      data: data,
      placeName: placeName,
      lat: lat,
      lng: lng,
      date: DateTime.parse(date),
    );
  }

  String _toAladhanDate(String isoDate) {
    final parts = isoDate.split("-");
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  Future<String> _resolvePlaceName(double lat, double lng) async {
    final apiKey = dotenv.env['HARITA_API_KEY'] ?? "";
    if (apiKey.isEmpty) return "Konumun";

    try {
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey&language=tr";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final results = body['results'] as List?;

        if (results != null && results.isNotEmpty) {
          final components = results.first['address_components'] as List;
          final match = components.firstWhere(
            (c) => (c['types'] as List).contains('administrative_area_level_2') ||
                (c['types'] as List).contains('locality'),
            orElse: () => null,
          );
          if (match != null) return match['long_name'] as String;
        }
      }
    } catch (_) {}

    return "Konumun";
  }
}
