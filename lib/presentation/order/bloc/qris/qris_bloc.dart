import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/midtrans_remote_datasource.dart';
import 'package:fic11_jilid1/data/models/response/qris_response_model.dart';
import 'package:fic11_jilid1/data/models/response/qris_status_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qris_event.dart';
part 'qris_state.dart';
part 'qris_bloc.freezed.dart';

class QrisBloc extends Bloc<QrisEvent, QrisState> {
  final MidtransRemoteDatasource midtransRemoteDatasource;
  QrisBloc(this.midtransRemoteDatasource) : super(_Initial()) {
    on<_GenerateQRCode>(_generateQRCode);
    on<_CheckPaymentStatus>(_checkPaymentStatus);
  }

  Future<void> _generateQRCode(
    _GenerateQRCode event,
    Emitter<QrisState> emit,
  ) async {
    emit(const _Loading());
    final response = await midtransRemoteDatasource.generateQRCode(
      orderId: event.orderId,
      grossAmount: event.grossAmount,
    );

    emit(_QrisResponse(qrisResponseModel: response));
  }

  Future<void> _checkPaymentStatus(
    _CheckPaymentStatus event,
    Emitter<QrisState> emit,
  ) async {
    final response = await midtransRemoteDatasource.checkPaymentStatus(
        orderId: event.orderId);
    if (response.transactionStatus == 'settlement') {
      emit(const _Success(message: 'Pembayaran Berhasil'));
    }
  }
}
