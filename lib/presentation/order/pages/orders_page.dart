import 'dart:developer';

import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:fic11_jilid1/core/components/menu_button.dart';
import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic11_jilid1/presentation/home/models/order_item.dart';
import 'package:fic11_jilid1/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_jilid1/presentation/order/widgets/order_card.dart';
import 'package:fic11_jilid1/presentation/order/widgets/payment_cash_dialog.dart';
import 'package:fic11_jilid1/presentation/order/widgets/payment_qris_dialog.dart';
import 'package:fic11_jilid1/presentation/order/widgets/process_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final indexValue = ValueNotifier(0);

  List<OrderItem> orders = [];

  int totalPrice = 0;
  int calculateTotalPrice(List<OrderItem> orders) {
    return orders.fold(
        0,
        (previousValue, element) =>
            previousValue + element.product.price * element.quantity);
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Assets.icons.delete.svg(),
          ),
        ],
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          return state.maybeWhen(
              orElse: () => const Center(child: Text('No Data')),
              success: (data, quantity, total) {
                if (data.isEmpty) {
                  return const Center(child: Text('No Data'));
                }
                totalPrice = total;
                orders = data;
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SpaceHeight(20.0),
                  itemBuilder: (context, index) => OrderCard(
                    padding: paddingHorizontal,
                    data: data[index],
                    onDeleteTap: () {
                      // orders.removeAt(index);
                      // setState(() {});
                    },
                  ),
                );
              });
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  success: (products, totalQuantity, totalPrice, paymentMethod,
                      nominalBayar, idKasir, namaKasir) {
                    return ValueListenableBuilder(
                      valueListenable: indexValue,
                      builder: (context, value, _) => Row(
                        children: [
                          const SpaceWidth(10.0),
                          MenuButton(
                            iconPath: Assets.icons.cash.path,
                            label: 'Tunai',
                            isActive: value == 1,
                            onPressed: () {
                              indexValue.value = 1;
                              context
                                  .read<OrderBloc>()
                                  .add(OrderEvent.addPaymentMethod(
                                    paymentMethod: 'cash',
                                    orders: orders,
                                  ));
                            },
                          ),
                          const SpaceWidth(10.0),
                          MenuButton(
                            iconPath: Assets.icons.qrCode.path,
                            label: 'QRIS',
                            isActive: value == 2,
                            onPressed: () {
                              indexValue.value = 2;
                              context
                                  .read<OrderBloc>()
                                  .add(OrderEvent.addPaymentMethod(
                                    paymentMethod: 'QRIS',
                                    orders: orders,
                                  ));
                            },
                          ),
                          const SpaceWidth(10.0),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SpaceHeight(20.0),
            ProcessButton(
              onPressed: () async {
                if (indexValue.value == 0) {
                } else if (indexValue.value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => PaymentCashDialog(
                      price: totalPrice,
                    ),
                  );
                } else if (indexValue.value == 2) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => PaymentQrisDialog(
                      price: totalPrice,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
