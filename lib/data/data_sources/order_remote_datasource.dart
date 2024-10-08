import 'dart:developer';

import 'package:fic11_jilid1/core/constants/variables.dart';
import 'package:fic11_jilid1/data/data_sources/auth_local_datasource.dart';
import 'package:fic11_jilid1/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDatasource {
  Future<bool> sendOrder(OrderRequestModel requestModel) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orderApi');
    final jwtToken = await AuthLocalDatasource().getToken();

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log('Request Model To API: ${requestModel.toMap()}');

    final response = await http.post(
      url,
      headers: headers,
      body: requestModel.toJson(),
    );

    if (response.statusCode == 201) {
      log('Success: ${response.body}');
      return true;
    } else {
      log('Fail : ${response.body}');
      return false;
    }
  }
}
