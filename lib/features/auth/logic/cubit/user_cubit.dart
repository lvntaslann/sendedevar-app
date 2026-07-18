import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/user_model.dart';
import '../../data/services/user_services.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserServices userServices;

  UserCubit(this.userServices) : super(const UserState());

  Future<void> signUp({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final user = await userServices.signUpWithEmail(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );

      if (user != null) {
        final userData = await userServices.fetchUserData();
        if (userData != null) {
          final isAdmin = await userServices.checkIsAdmin(user.uid);
          emit(state.copyWith(
            user: UserModel.fromMap(userData, user.uid),
            isLoading: false,
            isSignIn: true,
            isAdmin: isAdmin,
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: "Kayıt başarısız.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final user = await userServices.signInWithEmail(email, password);

      if (user != null) {
        final userData = await userServices.fetchUserData();
        if (userData != null) {
          final isAdmin = await userServices.checkIsAdmin(user.uid);
          emit(state.copyWith(
            user: UserModel.fromMap(userData, user.uid),
            isLoading: false,
            isAuthenticated: true,
            isAdmin: isAdmin,
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: "Giriş başarısız.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadUserData() async {
    try {
      emit(state.copyWith(isLoading: true));
      final userData = await userServices.fetchUserData();
      if (userData != null && userServices.user != null) {
        final isAdmin = await userServices.checkIsAdmin(userServices.user!.uid);
        emit(state.copyWith(
          user: UserModel.fromMap(userData, userServices.user!.uid),
          isAuthenticated: true,
          isLoading: false,
          isAdmin: isAdmin,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    await userServices.signOut();
    emit(const UserState(isAuthenticated: false));
  }
}
