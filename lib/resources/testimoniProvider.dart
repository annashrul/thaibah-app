import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;

import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class TestimoniProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<TestimoniModel> fetchTesti(var param,var page, var limit) async{
//    var _url;
//    if(param == 0){
//      _url = 'testi?tipe=0&page=0&limit=$limit';
//    }
//    if(param == 1){
//      _url = 'testi?tipe=1&page=0&limit=$limit';
//    }
		final token = await userRepository.getToken();
    final response = await client.get(
        ApiService().baseUrl+'testi?tipe=$param&page=$page&limit=$limit',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return compute(testimoniModelFromJson,response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load promosi');
    }
  }
}
