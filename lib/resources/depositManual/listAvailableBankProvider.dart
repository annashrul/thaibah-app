import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/depositManual/listAvailableBank.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class ListAvailableBankProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ListAvailableBankModel> fetchListAvailableBank() async{
    final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'transaction/deposit/availablebank',headers: {'Authorization':token});
    print(response.body);
    if (response.statusCode == 200) {
      return compute(listAvailableBankModelFromJson,response.body);
    } else {
      throw Exception('Failed to load bank');
    }
  }

}
