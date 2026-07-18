import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sende_de_var/features/channels/data/model/duty_model.dart';

import '../../data/services/duty_services.dart';
import 'duty_state.dart';

class DutyCubit extends Cubit<DutyState> {
  final DutyServices dutyServices;
  DutyCubit(this.dutyServices) : super(DutyState());

Future<void> getAllDuties(String channelId) async {
  try {
    emit(state.copyWith(isLoading: true));
    final duties = await dutyServices.fetchAllDuties(channelId);
    emit(state.copyWith(duty: duties, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: e.toString()));
  }
}

//save duty
Future<void> saveDuty(DutyModel duty, String channelId) async {
  try {
    await dutyServices.assignDuty(channelId, duty);
    emit(DutyState(duty: state.duty, isLoading: false));
  } catch (e) {
    rethrow;
  } 
}

// update duty status
Future<void> updateDutyStatus({
  required String channelId,
  required String memberId,
  required String dutyId,
  required String newStatus,
}) async {
  try {
    await dutyServices.updateDutyStatus(
      channelId: channelId,
      memberId: memberId,
      dutyId: dutyId,
      newStatus: newStatus,
    );
    await getAllDuties(channelId);
  } catch (e) {
    emit(state.copyWith(error: e.toString()));
  }
}
}