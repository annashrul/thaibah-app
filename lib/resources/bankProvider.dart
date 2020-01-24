import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/bankModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class BankProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<BankModel> fetchBank() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'transaction/withdraw/available',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(bankModelFromJson,response.body);
    } else {
      throw Exception('Failed to load bank');
    }
  }

}
