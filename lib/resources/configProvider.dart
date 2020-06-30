import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/checkerModel.dart';
import 'package:thaibah/Model/configModel.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class ConfigProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ConfigModel> fetchConfig() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'info/config',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(configModelFromJson,response.body);
    } else {
      throw Exception('Failed to load config');
    }
  }

  Future cekVersion() async{
    try{
      final token = await userRepository.getDataUser('token');
      final response = await client.get(
          ApiService().baseUrl+'info/checker',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
      ).timeout(Duration(seconds: ApiService().timerActivity));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return compute(checkerFromJson,response.body);
      } else {
        throw Exception('Failed to load cek versi');
      }
    }
    catch(e){
      return 'gagal';
    }
  }

}
