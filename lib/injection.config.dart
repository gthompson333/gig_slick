// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'features/core/bloc/core_bloc.dart' as _i494;
import 'features/core/repository/core_repository.dart' as _i910;
import 'features/core/repository/core_repository_impl.dart' as _i1050;
import 'features/create_slot/data/datasources/create_slot_remote_data_source.dart'
    as _i620;
import 'features/create_slot/data/repositories/create_slot_repository_impl.dart'
    as _i692;
import 'features/create_slot/domain/repositories/create_slot_repository.dart'
    as _i640;
import 'features/create_slot/presentation/bloc/create_slot_bloc.dart' as _i730;
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
  gh.factory<_i494.CoreBloc>(() => _i494.CoreBloc());
  gh.lazySingleton<_i126.AuthRepository>(() => _i454.AuthRepositoryImpl());
  gh.lazySingleton<_i910.CoreRepository>(() => _i1050.CoreRepositoryImpl());
  gh.lazySingleton<_i786.DashboardRemoteDataSource>(
    () => _i786.DashboardRemoteDataSourceImpl(),
  );
  gh.factory<_i224.CreateVenueRepository>(
    () => _i766.CreateVenueRepositoryImpl(),
  );
  gh.factory<_i198.AuthBloc>(() => _i198.AuthBloc(gh<_i126.AuthRepository>()));
  gh.lazySingleton<_i620.CreateSlotRemoteDataSource>(
    () => _i620.CreateSlotRemoteDataSourceImpl(),
  );
  gh.lazySingleton<_i314.DashboardRepository>(
    () => _i448.DashboardRepositoryImpl(gh<_i786.DashboardRemoteDataSource>()),
  );
  gh.factory<_i282.CreateVenueBloc>(
    () => _i282.CreateVenueBloc(gh<_i224.CreateVenueRepository>()),
  );
  gh.factory<_i172.DashboardBloc>(
    () => _i172.DashboardBloc(gh<_i314.DashboardRepository>()),
  );
  gh.lazySingleton<_i640.CreateSlotRepository>(
    () =>
        _i692.CreateSlotRepositoryImpl(gh<_i620.CreateSlotRemoteDataSource>()),
  );
  gh.factory<_i730.CreateSlotBloc>(
    () => _i730.CreateSlotBloc(gh<_i640.CreateSlotRepository>()),
  );
  return getIt;
}
