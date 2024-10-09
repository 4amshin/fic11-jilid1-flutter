import 'dart:developer';

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
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<int> _selectCategoryIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _fetchLocalData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchLocalData() {
    context.read<ProductBloc>().add(const ProductEvent.getLocal());
  }

  void onCategoryTap(int index) {
    _searchController.clear();
    _selectCategoryIndex.value = index;
    final String category = _getCategoryByIndex(index);
    context
        .read<ProductBloc>()
        .add(ProductEvent.getByCategory(category: category));
  }

  String _getCategoryByIndex(int index) {
    switch (index) {
      case 1:
        return 'drink';
      case 2:
        return 'food';
      case 3:
        return 'snack';
      default:
        return 'all';
    }
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
        body: RefreshIndicator(
          onRefresh: () async {
            log('Refresh Product List');
            context.read<ProductBloc>().add(const ProductEvent.getProduct());
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSearchInput(),
              const SpaceHeight(20.0),
              _buildCategoryMenu(),
              const SpaceHeight(35.0),
              const ProductList(),
              const SpaceHeight(30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return SearchInput(
      controller: _searchController,
      onChanged: (value) {
        if (value.length > 3) {
          context
              .read<ProductBloc>()
              .add(ProductEvent.searchProduct(query: value));
        }

        if (value.isEmpty) {
          context
              .read<ProductBloc>()
              .add(const ProductEvent.fethcAllFromState());
        }
      },
    );
  }

  Widget _buildCategoryMenu() {
    return ValueListenableBuilder(
      valueListenable: _selectCategoryIndex,
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
    );
  }
}
