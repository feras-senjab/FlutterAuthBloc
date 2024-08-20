import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_auth_bloc/Features/AppGate/UI/app_gate.dart';
import 'package:flutter_auth_bloc/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:firebase_repository/config.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:flutter_auth_bloc/Config/simple_bloc_observer.dart';
import 'package:flutter_auth_bloc/Features/Auth/Login/UI/login_screen.dart';
import 'package:flutter_auth_bloc/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_auth_bloc/Global/Style/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

import 'Features/Auth/bloc/auth_bloc.dart';

void main() async {
  //! IMPORTANT: DEFINE DEPLOYMENT ENVIRONMENT BEFORE BUILD OR DEPLOY.
  const DeploymentEnv deploymentEnv = DeploymentEnv.testing;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = SimpleBlocObserver();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(
        create: (context) => AuthRepository(),
      ),
      RepositoryProvider<FirebaseUsersRepository>(
        create: (context) =>
            FirebaseUsersRepository(deploymentEnv: deploymentEnv),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          )..add(AppStarted()),
        ),
        BlocProvider(
          create: (BuildContext context) => UserModelCubit(
            authBloc: context.read<AuthBloc>(),
            usersRepository: context.read<FirebaseUsersRepository>(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => LogoutCubit(
            authRepository: context.read<AuthRepository>(),
            authBloc: context.read<AuthBloc>(),
            userModelCubit: context.read<UserModelCubit>(),
            //userDataRepository: context.read<UserDataRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Bloc Auth Test',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
            useMaterial3: true,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            // Rebuild the UI only when the auth state transitions from 'unknown' to a known state.
            // This ensures that the main screen is initially displayed based on the authentication status.
            // Subsequent UI updates or navigations (e.g., login, signup, logout) are handled manually
            // and do not trigger unnecessary rebuilds of the main screen.
            buildWhen: (previous, current) =>
                previous.status == AuthStatus.unknown && previous != current,
            builder: (context, state) {
              switch (state.status) {
                case AuthStatus.authenticated:
                  return const AppGate();

                case AuthStatus.unauthenticated:
                  return const LoginScreen();

                default:
                  // ! can be replaced with splash or another appropriate Ui.
                  return const LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}
