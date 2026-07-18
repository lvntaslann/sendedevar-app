import '../../data/model/prayer_time_model.dart';

class PrayerTimeState {
  final PrayerTimesResponse? data;
  final bool isLoading;
  final String? error;
  final String? mosqueName;
  final double? mosqueLat;
  final double? mosqueLng;
  final bool isSuccess;

  PrayerTimeState({
    this.data,
    this.isLoading = false,
    this.error,
    this.mosqueName,
    this.mosqueLat,
    this.mosqueLng,
    this.isSuccess = false,
  });

  PrayerTimeState copyWith({
    PrayerTimesResponse? data,
    bool? isLoading,
    String? error,
    String? mosqueName,
    double? mosqueLat,
    double? mosqueLng,
    bool? isSuccess,
  }) {
    return PrayerTimeState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      mosqueName: mosqueName ?? this.mosqueName,
      mosqueLat: mosqueLat ?? this.mosqueLat,
      mosqueLng: mosqueLng ?? this.mosqueLng,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
