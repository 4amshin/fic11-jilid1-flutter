import 'package:fic11_jilid1/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/home/widgets/product_card.dart';
import 'package:fic11_jilid1/presentation/home/widgets/product_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return state.maybeWhen(
            orElse: () => const Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: ProductEmpty(),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            success: (product) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: product.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.65,
                  crossAxisCount: 2,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 30.0,
                ),
                itemBuilder: (context, index) => ProductCard(
                  data: product[index],
                  onCartButton: () => context
                      .read<CheckoutBloc>()
                      .add(CheckoutEvent.addCheckout(product: product[index])),
                ),
              );
            });
      },
    );
  }
}
