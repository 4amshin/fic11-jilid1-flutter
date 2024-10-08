import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/core/constants/colors.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/manage/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncDataPage extends StatelessWidget {
  const SyncDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          BlocConsumer<ProductBloc, ProductState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => ElevatedButton(
                  onPressed: () => context
                      .read<ProductBloc>()
                      .add(const ProductEvent.getProduct()),
                  child: const Text('Sync Data Product'),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (data) async {
                  await ProductLocalDatasource.instance.removeAllProduct();
                  await ProductLocalDatasource.instance
                      .insertAllProduct(data.toList());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'Sync data product success',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SpaceHeight(20),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => ElevatedButton(
                  onPressed: () => context
                      .read<SyncOrderBloc>()
                      .add(const SyncOrderEvent.sendOrder()),
                  child: const Text('Sync Data Order'),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  success: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.primary,
                        content: Text(
                          'Sync data orders success',
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
