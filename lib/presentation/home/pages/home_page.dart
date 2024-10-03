import 'dart:async';
import 'dart:developer';

import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:fic11_jilid1/core/components/menu_button.dart';
import 'package:fic11_jilid1/core/components/search_input.dart';
import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/home/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<int> _selectCategoryIndex = ValueNotifier(0);
  StreamSubscription? _internetConnection;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _initializeInternetConnection();
  }

  @override
  void dispose() {
    _internetConnection?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeInternetConnection() {
    _internetConnection =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          _isOnline = true;
          log('Online');
          _fetchOnlineData();
          break;
        case InternetStatus.disconnected:
          _isOnline = false;
          log('Offline');
          _fetchLocalData();
          break;
      }
    });
  }

  void _fetchOnlineData() {
    // Kirim event untuk mengambil data online
    context.read<ProductBloc>().add(const ProductEvent.getProduct());

    // Buat listener yang hanya merespon event pengambilan data online
    context.read<ProductBloc>().stream.listen((state) async {
      if (_isOnline) {
        state.maybeWhen(
          success: (data) async {
            // Hanya simpan data ke local storage jika pengambilan data online sukses
            await ProductLocalDatasource.instance.removeAllProduct();
            await ProductLocalDatasource.instance.insertAllProduct(data);
            log('Data Saved to Local Storage');
          },
          orElse: () {},
        );
      }
    });
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
        body: ListView(
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
