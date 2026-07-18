import '../../data/model/user_model.dart';

class UserState {
  final UserModel? user;
  final bool isLoading;
  final bool isSignIn;
  final bool isAuthenticated;
  final bool isAdmin;
  final String? error;

  const UserState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isSignIn = false,
    this.isAdmin = false,
    this.error,
  });

  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isAuthenticated,
    bool? isSignIn,
    bool? isAdmin,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSignIn: isSignIn ?? this.isSignIn,
      isAdmin: isAdmin ?? this.isAdmin,
      error: error,
    );
  }
}
