import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_auth_bloc/Features/Auth/bloc/auth_bloc.dart';
import 'package:flutter_auth_bloc/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_auth_bloc/Global/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({
    required this.authRepository,
    required this.authBloc,
    required this.userModelCubit,
  }) : super(const LogoutState());

  final AuthRepository authRepository;
  final AuthBloc authBloc;
  final UserModelCubit userModelCubit;

  void logout() async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await authRepository.signOut();
      emit(state.copyWith(status: StateStatus.success));
      authBloc.add(AuthLogoutRequested());
      // re-init user data (reset state)..
      userModelCubit.resetState();
    } catch (e) {
      emit(state.copyWith(status: StateStatus.failure));
    }
  }
}
