import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class DetailCheckoutSuplemenProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future fetchDetailCheckoutSuplemen() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.post(
        ApiService().baseUrl+'transaction/checkout/detail',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"},
        body: {}
    );
    print(response.statusCode);
    print(response.body);
    var results;
    if (response.statusCode == 200) {
      results = compute(getDetailChekoutSuplemenModelFromJson,response.body);
//      results =  compute(addressModelFromJson,response.body);
    } else if(response.statusCode == 400) {
      results = General.fromJson(json.decode(response.body));
    }
    return results;

//    final token = await userRepository.getToken();
//    final response = await client.post(
//      ApiService().baseUrl+'transaction/checkout/detail',
//      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
//    );
//    print(response.body);
//    print(response.statusCode);
//    if (response.statusCode == 200) {
//      return compute(getDetailChekoutSuplemenModelFromJson,response.body);
//    }
  }

}
