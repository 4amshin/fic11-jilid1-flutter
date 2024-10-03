import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/presentation/order/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(_Initial()) {
    on<_FetchHistory>(_fetchHistory);
  }

  Future<void> _fetchHistory(
    _FetchHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const _Loading());
    final data = await ProductLocalDatasource.instance.getAllOrders();
    emit(_Success(histories: data));
  }
}
