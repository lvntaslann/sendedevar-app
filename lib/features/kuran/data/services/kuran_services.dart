import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:sende_de_var/core/constants/kuran_ayet_data.dart';
import 'dart:convert';
import 'package:sende_de_var/features/kuran/data/model/kuran_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KuranServices {
  final Random _random = Random();
  final String _baseUrl = dotenv.env['KURAN_API_URL']!;

  Future<KuranModel?> fetchRandomAyah({
    int numberOfAyahs = 3,
    String arabicEdition = 'quran-uthmani',
    String turkishEdition = 'tr.diyanet',
  }) async {
    try {
      final surahKeys = surahList.keys.toList();
      final randomSurahNumber = surahKeys[_random.nextInt(surahKeys.length)];
      final surahData = surahList[randomSurahNumber]!;

      final url = Uri.parse(
        '$_baseUrl/surah/$randomSurahNumber/editions/$arabicEdition,$turkishEdition',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;

        final arabicAyahs = data.firstWhere(
          (e) => e['edition']['identifier'] == arabicEdition,
          orElse: () => {'ayahs': []},
        )['ayahs'] as List;

        final turkishAyahs = data.firstWhere(
          (e) => e['edition']['identifier'] == turkishEdition,
          orElse: () => {'ayahs': []},
        )['ayahs'] as List;

        if (arabicAyahs.isEmpty || turkishAyahs.isEmpty) return null;

        final startIndex = _random.nextInt(arabicAyahs.length);
        final endIndex = (startIndex + numberOfAyahs) > arabicAyahs.length
            ? arabicAyahs.length
            : startIndex + numberOfAyahs;

        final arabicText = arabicAyahs
            .sublist(startIndex, endIndex)
            .map((e) => e['text'] ?? '')
            .join(' ');

        final turkishText = turkishAyahs
            .sublist(startIndex, endIndex)
            .map((e) => e['text'] ?? '')
            .join(' ');

        final title = '${surahData['name']} ${startIndex + 1}-${endIndex}';

        return KuranModel(
          title: title,
          arabicText: arabicText,
          turkishText: turkishText,
        );
      } else {
        debugPrint('Hata: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return null;
    }
  }
}

