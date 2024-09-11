import 'package:fic11_jilid1/core/constants/variables.dart';
import 'package:fic11_jilid1/data/data_sources/auth_local_datasource.dart';
import 'package:fic11_jilid1/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final loginToken = await AuthLocalDatasource().getToken();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $loginToken',
    };

    const baseUrl = "${Variables.baseUrl}/api/productApi";

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed get List Product');
    }
  }
}
