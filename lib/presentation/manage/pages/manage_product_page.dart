import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/core/extensions/build_context_ext.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/manage/pages/add_product_page.dart';
import 'package:fic11_jilid1/presentation/manage/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({super.key});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(const ProductEvent.getProduct());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const Center(child: CircularProgressIndicator()),
              success: (products) {
                return ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const SpaceHeight(20),
                  itemBuilder: (context, index) => ProductItem(
                    data: products[index],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(const AddProductPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
