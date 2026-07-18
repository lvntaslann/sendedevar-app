import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/fetch_time_util.dart';
import '../../data/services/prayer_time_services.dart';
import '../../data/services/mosque_services.dart';
import 'prayer_time_state.dart';
import '../../data/model/prayer_time_model.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final PrayerTimeService service;
  final NearbyPlacesService _mosqueService = NearbyPlacesService();

  PrayerTimeCubit(this.service) : super(PrayerTimeState());

  Future<void> getPrayerTimes({
    required double lat,
    required double lng,
    required String date,
  }) async {
    print("========== API ÇAĞRISI BAŞLADI ==========");
    emit(state.copyWith(isLoading: true, error: null));

    PrayerTimesResponse? prayerResult;
    String? prayerError;

    /// 1️⃣ Namaz vakitlerini getir (Hata verirse uygulamayı durdurmasın, kaydetsin)
    try {
      prayerResult = await service.fetchPrayerTimes(
        lat: lat,
        lng: lng,
        date: date,
      );
    } catch (e) {
      print("NAMAZ API HATA: $e");
      prayerError = e.toString();
    }

    /// 2️⃣ En yakın cami detaylarını getir (Namaz API'den bağımsız çalışsın)
    String? mosqueName;
    double? mosqueLat;
    double? mosqueLng;

    try {
      final mosqueDetails = await _mosqueService.fetchNearestMosqueDetails(
        lat,
        lng,
      );
      if (mosqueDetails != null) {
        mosqueName = mosqueDetails['name'];
        mosqueLat = mosqueDetails['lat'];
        mosqueLng = mosqueDetails['lng'];
        print("CAMİ BULUNDU: $mosqueName ($mosqueLat, $mosqueLng)");
      }
    } catch (e) {
      print("CAMİ SERVİSİ HATA: $e");
    }

    /// 3️⃣ State'i güncelle
    emit(
      state.copyWith(
        data: prayerResult,
        mosqueName: mosqueName,
        mosqueLat: mosqueLat,
        mosqueLng: mosqueLng,
        isLoading: false,
        isSuccess: prayerResult != null,
        error: prayerError,
      ),
    );

    /// 4️⃣ Cache kaydet (Eğer namaz vakti geldiyse)
    if (prayerResult != null) {
      await FetchTimeUtil.savePrayerTimes(jsonEncode(prayerResult.toJson()));
    }
  }

  Future<void> loadFromCache() async {
    final cachedData = await FetchTimeUtil.getPrayerTimes();
    if (cachedData != null) {
      try {
        final jsonData = jsonDecode(cachedData);
        emit(
          state.copyWith(
            data: PrayerTimesResponse.fromJson(jsonData),
            isLoading: false,
            isSuccess: true,
          ),
        );
      } catch (e) {
        print("CACHE PARSE HATA: $e");
      }
    }
  }
}
