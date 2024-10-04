import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:fic11_jilid1/core/constants/colors.dart';
import 'package:fic11_jilid1/core/extensions/int_ext.dart';
import 'package:fic11_jilid1/presentation/order/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryTransactionCard extends StatelessWidget {
  final OrderModel data;
  final EdgeInsetsGeometry? padding;
  const HistoryTransactionCard({
    super.key,
    required this.data,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Parse transactionTime dan format tanggal
    final DateTime parsedDate = DateTime.parse(data.transactionTime);
    final String formattedDate =
        DateFormat('dd MMM yyyy - HH:mm', 'id_ID').format(parsedDate);

    return Container(
      margin: padding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 48.0,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0,
            color: AppColors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: ListTile(
        leading: Assets.icons.payments.svg(),
        title: Text(
          data.paymentMethod,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              data.totalPrice.currencyFormatRp,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'by ${data.namaKasir}',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
