import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:fic11_jilid1/core/components/menu_button.dart';
import 'package:fic11_jilid1/core/components/search_input.dart';
import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/home/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final indexValue = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  void onCategoryTap(int index) {
    searchController.clear();
    indexValue.value = index;
    String category = 'all';
    switch (index) {
      case 0:
        category = 'all';
        break;
      case 1:
        category = 'drink';
        break;
      case 2:
        category = 'food';
        break;
      case 3:
        category = 'snack';
        break;
    }
    context
        .read<ProductBloc>()
        .add(ProductEvent.getByCategory(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SearchInput(
              controller: searchController,
              onChanged: (value) {
                // indexValue.value = 0;
                // searchResults = products
                //     .where((e) =>
                //         e.name.toLowerCase().contains(value.toLowerCase()))
                //     .toList();
                // setState(() {});
              },
            ),
            const SpaceHeight(20.0),
            ValueListenableBuilder(
              valueListenable: indexValue,
              builder: (context, value, _) => Row(
                children: [
                  MenuButton(
                    iconPath: Assets.icons.allCategories.path,
                    label: 'Semua',
                    isActive: value == 0,
                    onPressed: () => onCategoryTap(0),
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.drink.path,
                    label: 'Minuman',
                    isActive: value == 1,
                    onPressed: () => onCategoryTap(1),
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.food.path,
                    label: 'Makanan',
                    isActive: value == 2,
                    onPressed: () => onCategoryTap(2),
                  ),
                  const SpaceWidth(10.0),
                  MenuButton(
                    iconPath: Assets.icons.snack.path,
                    label: 'Snack',
                    isActive: value == 3,
                    onPressed: () => onCategoryTap(3),
                  ),
                ],
              ),
            ),
            const SpaceHeight(35.0),
            const ProductList(),
            const SpaceHeight(30.0),
          ],
        ),
      ),
    );
  }
}
