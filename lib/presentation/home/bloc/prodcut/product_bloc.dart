import 'package:bloc/bloc.dart';
import 'package:fic11_jilid1/data/data_sources/product_local_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/product_remote_datasource.dart';
import 'package:fic11_jilid1/data/models/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    emit(ProductState.success(product: newProducts));
  }

  Future<void> _addProduct(
    _AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const _Loading());
    final newProduct =
        await ProductLocalDatasource.instance.insertProduct(event.product);
    products.add(newProduct);
    emit(ProductState.success(product: products));
  }
}
