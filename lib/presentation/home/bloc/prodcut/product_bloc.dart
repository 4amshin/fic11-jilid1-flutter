import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/product_remote_datasource.dart';
import 'package:fic11_jilid1/data/models/request/product_request_model.dart';
import 'package:fic11_jilid1/data/models/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource datasource;
  List<Product> products = [];

  ProductBloc(this.datasource) : super(const _Initial()) {
    on<_GetProduct>(_getProduct);
    on<_GetLocal>(_getLocal);
    on<_GetByCategory>(_getByCategory);
    on<_AddProduct>(_addProduct);
    on<_SearchProduct>(_searchProduct);
    on<_FetchAllFromState>(_fetchAllFromState);
  }

  Future<void> _getProduct(
    _GetProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final result = await datasource.getProducts();
    result.fold(
      (error) => emit(_Error(message: error)),
      (product) {
        products = product.data;
        emit(_Success(product: product.data));
      },
    );
  }

  Future<void> _getLocal(
    _GetLocal event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final localData = await ProductLocalDatasource.instance.getAllProduct();
    products = localData;
    emit(_Success(product: products));
  }

  Future<void> _getByCategory(
    _GetByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final newProducts = event.category == 'all'
        ? products
        : products
            .where((element) => element.category == event.category)
            .toList();
    emit(_Success(product: newProducts));
  }

  Future<void> _addProduct(
    _AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());

    final requestData = ProductRequestModel(
      name: event.product.name,
      price: event.product.price,
      stock: event.product.stock,
      category: event.product.category,
      image: event.image,
      isBestSeller: event.product.isBestSeller ? 1 : 0,
    );

    log("Sengin Request: ${requestData.toMap()}");
    final response =
        await datasource.addProduct(productRequestModel: requestData);
    log("Response Status Code : $response");
    response.fold(
      (error) => emit(_Error(message: error)),
      (success) {
        products.add(success.data);
        emit(_Success(product: products));
      },
    );
  }

  void _searchProduct(
    _SearchProduct event,
    Emitter<ProductState> emit,
  ) {
    emit(const _Loading());
    final newProducts = products
        .where((element) =>
            element.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(_Success(product: newProducts));
  }

  void _fetchAllFromState(
    _FetchAllFromState event,
    Emitter<ProductState> emit,
  ) {
    emit(const _Loading());
    emit(_Success(product: products));
  }
}
