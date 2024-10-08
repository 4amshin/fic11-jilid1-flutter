import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/order_remote_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/data/models/request/order_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_order_event.dart';
part 'sync_order_state.dart';
part 'sync_order_bloc.freezed.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  SyncOrderBloc(this.orderRemoteDatasource) : super(const _Initial()) {
    on<_SendOrder>(_sendOrder);
  }

  Future<void> _sendOrder(
    _SendOrder event,
    Emitter<SyncOrderState> emit,
  ) async {
    emit(const _Loading());

    final orderIsSyncZero =
        await ProductLocalDatasource.instance.getOrderByIsSync();

    for (final order in orderIsSyncZero) {
      final orderItems = await ProductLocalDatasource.instance
          .getOrderItemByOrderIdLocal(order.id!);

      final orderRequest = OrderRequestModel(
        transactionTime: order.transactionTime,
        totalPrice: order.totalPrice,
        totalItem: order.totalQuantity,
        kasirId: order.idKasir,
        paymentMethod: order.paymentMethod,
        orderItems: orderItems,
      );

      log(orderRequest.toString());

      final response = await orderRemoteDatasource.sendOrder(orderRequest);
      if (response) {
        await ProductLocalDatasource.instance.updateIsSyncOrderById(order.id!);
      }
    }

    emit(const _Success());
  }
}
