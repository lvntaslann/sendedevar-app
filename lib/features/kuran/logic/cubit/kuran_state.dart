
import 'package:sende_de_var/features/kuran/data/model/kuran_model.dart';

class KuranState {
  final List<KuranModel> kuranData;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  KuranState({
    this.kuranData = const [],
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  KuranState copyWith({
    List<KuranModel>? kuranData,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return KuranState(
      kuranData: kuranData ?? this.kuranData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}