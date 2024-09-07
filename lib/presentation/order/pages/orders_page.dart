import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
