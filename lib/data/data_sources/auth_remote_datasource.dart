import 'package:dartz/dartz.dart';
import 'package:fic11_jilid1/core/constants/variables.dart';
import 'package:fic11_jilid1/data/data_sources/auth_local_datasource.dart';
import 'package:fic11_jilid1/data/models/request/login_request_model.dart';
import 'package:fic11_jilid1/data/models/response/login_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, LoginResponseModel>> login({
    required LoginRequestModel loginRequestModel,
  }) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    const baseUrl = "${Variables.baseUrl}/api/login";

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: loginRequestModel.toRawJson(),
    );

    if (response.statusCode == 200) {
      return right(LoginResponseModel.fromRawJson(response.body));
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    //get token from local storage
    final loginToken = await AuthLocalDatasource().getToken();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $loginToken',
    };

    const baseUrl = "${Variables.baseUrl}/api/logout";

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return const Right('Logout Successfully');
    } else {
      return const Left('Logout Failed');
    }
  }
}
