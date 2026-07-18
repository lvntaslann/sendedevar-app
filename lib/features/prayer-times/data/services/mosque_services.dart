import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NearbyPlacesService {
  final String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  NearbyPlacesService();

  Future<Map<String, dynamic>?> fetchNearestMosqueDetails(
    double lat,
    double lon,
  ) async {
    // API KEY'i burada okuyoruz
    final String apiKey = dotenv.env['HARITA_API_KEY'] ?? "";

    if (apiKey.isEmpty) {
      print("API KEY BOŞ GELDİ!");
      return null;
    }

    // DİKKAT: radius parametresi KALDIRILDI, rankby=distance EKLENDİ!
    // rankby=distance kullanıldığında radius parametresi kullanılamaz.
    final url =
        "$baseUrl?location=$lat,$lon&rankby=distance&type=mosque&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List results = body['results'] ?? [];

        if (results.isNotEmpty) {
          // Listenin ilk elemanı artık garanti olarak EN YAKIN olan camidir
          final location = results[0]['geometry']['location'];
          return {
            'name': results[0]['name'],
            'lat': location['lat'],
            'lng': location['lng'],
          };
        } else {
          print("Yakınlarda cami bulunamadı (Sonuç boş)");
        }
      } else {
        print("API Hatası (HTTP ${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      print("Bağlantı Hatası: $e");
    }
    return null;
  }
}
