import 'dart:async';
import 'dart:developer';

import 'package:fic11_jilid1/core/extensions/build_context_ext.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/presentation/home/models/order_item.dart';
import 'package:fic11_jilid1/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_jilid1/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:fic11_jilid1/presentation/order/models/order_model.dart';
import 'package:fic11_jilid1/presentation/order/widgets/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class PaymentQrisDialog extends StatefulWidget {
  final int price;
  const PaymentQrisDialog({
    super.key,
    required this.price,
  });

  @override
  State<PaymentQrisDialog> createState() => _PaymentQrisDialogState();
}

class _PaymentQrisDialogState extends State<PaymentQrisDialog> {
  String orderId = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    log('Proceeding with QRIS Payment');
    _initializeOrder();
  }

  void _initializeOrder() {
    orderId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<QrisBloc>().add(
          QrisEvent.generateQRCode(
            orderId: orderId,
            grossAmount: widget.price,
          ),
        );
  }

  void _startPaymentStatusCheck() {
    const checkInterval = Duration(seconds: 5);
    timer = Timer.periodic(checkInterval, (timer) {
      context
          .read<QrisBloc>()
          .add(QrisEvent.checkPaymentStatus(orderId: orderId));
    });
  }

  void _onPaymentSuccess(OrderModel orderModel) {
    timer?.cancel();
    ProductLocalDatasource.instance.saveOrder(orderModel);
    context.pop();
    showDialog(
      context: context,
      builder: (context) => const PaymentSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Pembayaran QRIS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          const SpaceHeight(6.0),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const Center(child: CircularProgressIndicator()),
                success: (products, totalQuantity, totalPrice, paymentMethod,
                    nominalBayar, idKasir, namaKasir) {
                  return _buildPaymentSection(
                    products: products,
                    totalQuantity: totalQuantity,
                    totalPrice: totalPrice,
                    paymentMethod: paymentMethod,
                    nominalBayar: nominalBayar,
                    idKasir: idKasir,
                    namaKasir: namaKasir,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection({
    required List<OrderItem> products,
    required int totalQuantity,
    required int totalPrice,
    required String paymentMethod,
    required int nominalBayar,
    required int idKasir,
    required String namaKasir,
  }) {
    return Container(
      width: context.deviceWidth,
      padding: const EdgeInsets.all(14.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocListener<QrisBloc, QrisState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  qrisResponse: (data) => _startPaymentStatusCheck(),
                  success: (message) {
                    final orderModel = OrderModel(
                      paymentMethod: paymentMethod,
                      nominalBayar: nominalBayar,
                      orders: products,
                      totalQuantity: totalQuantity,
                      totalPrice: totalPrice,
                      idKasir: idKasir,
                      namaKasir: namaKasir,
                      isSync: false,
                      transactionTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(DateTime.now()),
                    );
                    _onPaymentSuccess(orderModel);
                  });
            },
            child: BlocBuilder<QrisBloc, QrisState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox(),
                  qrisResponse: (data) {
                    log('Displaying QRIS Barcode');
                    return _buildQRCodeWidget(url: data.actions!.first.url!);
                  },
                  loading: () => _buildLoadingWidget(),
                );
              },
            ),
          ),
          const SpaceHeight(5.0),
          const Text(
            'Scan QRIS untuk melakukan pembayaran',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeWidget({required String url}) {
    return Container(
      width: 256.0,
      height: 256.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Center(
        child: Image.network(
          url,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: 256.0,
      height: 256.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
