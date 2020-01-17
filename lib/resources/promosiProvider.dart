import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;

import 'package:thaibah/Model/promosiModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class PromosiProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<PromosiModel> fetchPromosi() async{
		final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'promosi?limit=5',headers: {'Authorization':token});

    if (response.statusCode == 200) {
      return compute(promosiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }


  Future<PromosiModel> fetchListPromosi(var page, var limit) async{
    final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'promosi?page=$page&limit=$limit',headers: {'Authorization':token});
    print('promosi?page=$page&limit=$limit');
    if (response.statusCode == 200) {
      return compute(promosiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }
}
