// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/config/app_config.dart' as _i828;
import 'core/di/firebase_module.dart' as _i230;
import 'core/services/link_service.dart' as _i82;
import 'features/core/bloc/core_bloc.dart' as _i494;
import 'features/core/repository/core_repository.dart' as _i910;
import 'features/core/repository/core_repository_impl.dart' as _i1050;
import 'features/create_gig/bloc/create_gig_bloc.dart' as _i82;
import 'features/create_gig/data/repositories/create_gig_repository.dart'
    as _i258;
import 'features/create_gig/data/repositories/create_gig_repository_impl.dart'
    as _i411;
import 'features/create_gig/data/sources/create_gig_remote_data_source.dart'
    as _i632;
import 'features/create_venue/bloc/create_venue_bloc.dart' as _i282;
import 'features/create_venue/repository/create_venue_repository.dart' as _i224;
import 'features/create_venue/repository/create_venue_repository_impl.dart'
    as _i766;
import 'features/dashboard/bloc/dashboard_bloc.dart' as _i172;
import 'features/dashboard/data/repositories/dashboard_repository.dart'
    as _i314;
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i448;
import 'features/dashboard/data/sources/dashboard_remote_data_source.dart'
    as _i786;
import 'features/gig_details/bloc/gig_details_bloc.dart' as _i126;
import 'features/performer_web/bloc/performer_bloc.dart' as _i794;
import 'features/performer_web/data/performer_repository.dart' as _i955;
import 'features/sign_in/bloc/auth_bloc.dart' as _i198;
import 'features/sign_in/repository/auth_repository.dart' as _i126;
import 'features/sign_in/repository/auth_repository_impl.dart' as _i454;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final firebaseModule = _$FirebaseModule();
  gh.factory<_i494.CoreBloc>(() => _i494.CoreBloc());
  gh.singleton<_i828.AppConfig>(() => _i828.AppConfig());
  gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
  gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.auth);
  gh.lazySingleton<_i126.AuthRepository>(() => _i454.AuthRepositoryImpl());
  gh.lazySingleton<_i910.CoreRepository>(() => _i1050.CoreRepositoryImpl());
  gh.lazySingleton<_i82.LinkService>(
    () => _i82.LinkService(gh<_i828.AppConfig>()),
  );
  gh.lazySingleton<_i955.PerformerRepository>(
    () => _i955.PerformerRepositoryImpl(gh<_i974.FirebaseFirestore>()),
  );
  gh.factory<_i224.CreateVenueRepository>(
    () => _i766.CreateVenueRepositoryImpl(
      gh<_i974.FirebaseFirestore>(),
      gh<_i59.FirebaseAuth>(),
    ),
  );
  gh.lazySingleton<_i632.CreateGigRemoteDataSource>(
    () => _i632.CreateGigRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
  );
  gh.lazySingleton<_i786.DashboardRemoteDataSource>(
    () => _i786.DashboardRemoteDataSourceImpl(
      gh<_i974.FirebaseFirestore>(),
      gh<_i59.FirebaseAuth>(),
    ),
  );
  gh.factory<_i794.PerformerBloc>(
    () => _i794.PerformerBloc(gh<_i955.PerformerRepository>()),
  );
  gh.lazySingleton<_i314.DashboardRepository>(
    () => _i448.DashboardRepositoryImpl(gh<_i786.DashboardRemoteDataSource>()),
  );
  gh.factory<_i282.CreateVenueBloc>(
    () => _i282.CreateVenueBloc(gh<_i224.CreateVenueRepository>()),
  );
  gh.lazySingleton<_i258.CreateGigRepository>(
    () => _i411.CreateGigRepositoryImpl(gh<_i632.CreateGigRemoteDataSource>()),
  );
  gh.factory<_i82.CreateGigBloc>(
    () => _i82.CreateGigBloc(gh<_i258.CreateGigRepository>()),
  );
  gh.lazySingleton<_i198.AuthBloc>(
    () => _i198.AuthBloc(
      gh<_i126.AuthRepository>(),
      gh<_i314.DashboardRepository>(),
    ),
  );
  gh.factory<_i172.DashboardBloc>(
    () => _i172.DashboardBloc(
      gh<_i314.DashboardRepository>(),
      gh<_i82.LinkService>(),
    ),
  );
  gh.factory<_i126.GigDetailsBloc>(
    () => _i126.GigDetailsBloc(gh<_i314.DashboardRepository>()),
  );
  return getIt;
}

class _$FirebaseModule extends _i230.FirebaseModule {}
