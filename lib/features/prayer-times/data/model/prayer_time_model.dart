import 'package:flutter/material.dart';

class Place {
  final String country;
  final String name;
  final String stateName;
  final double lat;
  final double lng;

  Place({
    required this.country,
    required this.name,
    required this.stateName,
    required this.lat,
    required this.lng,
  });

  factory Place.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Place(country: "", name: "", stateName: "", lat: 0.0, lng: 0.0);
    }

    return Place(
      country: json['country'] ?? "",
      name: json['name'] ?? "",
      stateName: json['stateName'] ?? "",
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'name': name,
      'stateName': stateName,
      'lat': lat,
      'lng': lng,
    };
  }
}

class PrayerDay {
  final DateTime date;
  final List<String> times;

  PrayerDay({required this.date, required this.times});

  factory PrayerDay.fromJson(String dateKey, List<dynamic>? values) {
    return PrayerDay(
      date: DateTime.tryParse(dateKey) ?? DateTime.now(),
      times: values != null ? values.map((v) => v.toString()).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'times': times};
  }
}

class PrayerTimesResponse {
  final Place place;
  final List<PrayerDay> days;

  PrayerTimesResponse({required this.place, required this.days});

  factory PrayerTimesResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PrayerTimesResponse(place: Place.fromJson(null), days: []);
    }

    final place = Place.fromJson(json['place']);

    final times = json['times'] as Map<String, dynamic>? ?? {};

    final days = times.entries
        .map((e) => PrayerDay.fromJson(e.key, e.value as List<dynamic>?))
        .toList();

    days.sort((a, b) => a.date.compareTo(b.date));

    return PrayerTimesResponse(place: place, days: days);
  }

  Map<String, dynamic> toJson() {
    final timesMap = <String, dynamic>{};
    for (var day in days) {
      timesMap[day.date.toIso8601String()] = day.times;
    }

    return {'place': place.toJson(), 'times': timesMap};
  }
}

extension PrayerDayExtension on PrayerDay {
  String getUpcomingPrayer() {
    if (times.isEmpty) return "Vakit yok";

    final now = DateTime.now();

    final prayerLabels = ["İmsak", "Güneş", "Öğle", "İkindi", "Akşam", "Yatsı"];

    for (int i = 0; i < times.length && i < prayerLabels.length; i++) {
      final parts = times[i].split(":");
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) continue;

      final prayerTime = DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );

      if (prayerTime.isAfter(now)) {
        return prayerLabels[i];
      }
    }

    return "Yarın İmsak";
  }
}
