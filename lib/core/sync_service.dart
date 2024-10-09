// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/manage/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SyncService {
  Timer? _orderSyncTimer;
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

      // Ambil bloc sekali di awal
      final productBloc = context.read<ProductBloc>();
      final syncOrderBloc = context.read<SyncOrderBloc>();

      _startAutoSyncOrder(syncOrderBloc);

      await _syncProducts(productBloc);
      await _syncOrders(syncOrderBloc);
    } else {
      log("Device is Offline, sync will be attempted later.");
    }
  }

  Future<void> _syncProducts(ProductBloc productBloc) async {
    // Kirim event untuk mengambil data online
    productBloc.add(const ProductEvent.getProduct());

    // Buat listener yang hanya merespon event pengambilan data online
    productBloc.stream.listen((state) async {
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

  Future<void> _syncOrders(SyncOrderBloc syncOrderBloc) async {
    log("Syncing Orders Data to Server");
    syncOrderBloc.add(const SyncOrderEvent.sendOrder());

    syncOrderBloc.stream.listen((state) {
      state.maybeWhen(
        success: () => log("Orders synced successfully."),
        error: (error) => log("Failed to sync orders: $error"),
        orElse: () {},
      );
    });
  }

  void _startAutoSyncOrder(SyncOrderBloc syncOrderBloc) {
    // Batalkan timer jika sudah berjalan sebelumnya untuk mencegah duplikasi
    _orderSyncTimer?.cancel();

    // Jalankan setiap 1 menit
    _orderSyncTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      log("Auto Syncing Orders Data to Server");
      await _syncOrders(syncOrderBloc);
    });
  }

  void stopAutoSyncOrder() {
    _orderSyncTimer?.cancel();
    log("Periodic order sync stopped.");
  }
}
