import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/auth_remote_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource datasource;
  LogoutBloc(this.datasource) : super(const _Initial()) {
    on<_Logout>(_doLogout);
  }

  Future<void> _doLogout(
    _Logout event,
    Emitter<LogoutState> emit,
  ) async {
    emit(const _Loading());
    final result = await datasource.logout();
    result.fold(
      (error) => emit(_Error(error: error)),
      (success) => emit(_Success(success: success)),
    );
  }
}
