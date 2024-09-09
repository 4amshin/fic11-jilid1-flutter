import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/login_remote_datasource.dart';
import 'package:fic11_jilid1/data/models/request/login_request_model.dart';
import 'package:fic11_jilid1/data/models/response/login_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRemoteDatasource datasources;

  LoginBloc(this.datasources) : super(const _Initial()) {
    on<_Login>(_doLogin);
  }

  Future<void> _doLogin(
    _Login event,
    Emitter<LoginState> emit,
  ) async {
    emit(const _Loading());
    final result =
        await datasources.login(loginRequestModel: event.loginRequestModel);
    result.fold(
      (error) => emit(_Error(message: error)),
      (loginResponseModel) =>
          emit(_Success(loginResponseModel: loginResponseModel)),
    );
  }
}
