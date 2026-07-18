import 'package:sende_de_var/features/channels/data/model/duty_model.dart';

class DutyState {
  final List<DutyModel> duty;
  final bool isLoading;
  final String? error;

  DutyState({
    this.duty = const [],
    this.isLoading = false,
    this.error,
  });

  DutyState copyWith({
    List<DutyModel>? duty,
    bool? isLoading,
    String? error,
  }) {
    return DutyState(
      duty: duty ?? this.duty,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}