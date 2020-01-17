import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class DetailCheckoutSuplemenProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<GetDetailChekoutSuplemenModel> fetchDetailCheckoutSuplemen() async{
    final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'transaction/checkout/detail',headers: {'Authorization':token});
    print(response.body);
    if (response.statusCode == 200) {
      return compute(getDetailChekoutSuplemenModelFromJson,response.body);
    }
  }

}
