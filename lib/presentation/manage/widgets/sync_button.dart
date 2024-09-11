import 'package:fic11_jilid1/core/components/buttons.dart';
import 'package:fic11_jilid1/core/constants/colors.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/product_remote_datasource.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(ProductRemoteDatasource()),
      child: BlocConsumer<ProductBloc, ProductState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => Button.filled(
              onPressed: () {
                context.read<ProductBloc>().add(
                      const ProductEvent.getProduct(),
                    );
              },
              label: 'Sync Data',
            ),
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: (data) async {
              await ProductLocalDatasource.instance.removeAllProduct();
              await ProductLocalDatasource.instance.insertAllProduct(data);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sync Data Product Success'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
