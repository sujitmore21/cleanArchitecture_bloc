import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/festures/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/festures/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/festures/auth/domain/usecases/current_user.dart';
import 'package:blog_app/festures/auth/domain/usecases/user_login.dart';
import 'package:blog_app/festures/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/festures/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // DataSource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // UseCases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
      ),
    );
}
