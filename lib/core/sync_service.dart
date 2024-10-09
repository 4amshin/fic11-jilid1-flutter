import 'dart:developer';

import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  Future<void> syncData(BuildContext context) async {
    bool isOnline = await InternetConnection().hasInternetAccess;

    if (isOnline) {
      log("Device is Online");
      log("Syncing Data.....");
      // ignore: use_build_context_synchronously
      await _syncProducts(context);
    } else {
      log("Device is Offline, sync will be attempted later.");
    }
  }

  Future<void> _syncProducts(BuildContext context) async {
    // Kirim event untuk mengambil data online
    context.read<ProductBloc>().add(const ProductEvent.getProduct());

    // Buat listener yang hanya merespon event pengambilan data online
    context.read<ProductBloc>().stream.listen((state) async {
      state.maybeWhen(
        success: (data) async {
          // Hanya simpan data ke local storage jika pengambilan data online sukses
          await ProductLocalDatasource.instance.removeAllProduct();
          await ProductLocalDatasource.instance.insertAllProduct(data);
          log('Saving Data to LocalStorage');
        },
        orElse: () {},
      );
    });
  }
}
