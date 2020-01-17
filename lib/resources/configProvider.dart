import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/configModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class ConfigProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ConfigModel> fetchConfig() async{
    final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'info/config',headers: {'Authorization':token});
    if (response.statusCode == 200) {
      return compute(configModelFromJson,response.body);
    } else {
      throw Exception('Failed to load config');
    }
  }

}
