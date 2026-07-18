import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sende_de_var/features/kuran/data/services/kuran_services.dart';
import 'package:sende_de_var/features/kuran/logic/cubit/kuran_state.dart';

import '../../data/model/kuran_model.dart';

class KuranCubit extends Cubit<KuranState> {
  final KuranServices kuranService;
  static const int batchSize = 10;

  KuranCubit(this.kuranService) : super(KuranState());

  Future<void> fetchMoreAyah() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      List<KuranModel> newAyahs = [];

      for (int i = 0; i < batchSize; i++) {
        final ayahData = await kuranService.fetchRandomAyah();
        if (ayahData != null) {
          newAyahs.add(ayahData);
        }
      }

      emit(state.copyWith(
        kuranData: [...state.kuranData, ...newAyahs],
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

