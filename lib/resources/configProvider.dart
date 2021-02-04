import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/checkerMemberModel.dart';
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
    print("#################### RESPON CONFIG PROVIDER $response ################################");
    if (response.statusCode == 200) {
      return compute(configModelFromJson,response.body);
    } else {
      throw Exception('Failed to load config');
    }
  }

  Future cekVersion() async{
    try{
//      final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIzNWJjMTdiMi04MGYxLTQwOTEtYjYzNC05NDM4NTUzNGE3YjAiLCJpYXQiOjE1OTM3NzI3MjMsImV4cCI6MTU5NjM2NDcyM30.KfdXn8SbnkpV9xAcGX7vj-9QxK_y-YeXoEdVEsHDGvE";
      final token = await userRepository.getDataUser('token');
      final response = await client.get(
          ApiService().baseUrl+'info/checker',
          headers: {'Authorization':'','username':ApiService().username,'password':ApiService().password}
      );
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

  Future checkerMember() async{
    try{
      final token = await userRepository.getDataUser('token');
      final response = await client.get(
          ApiService().baseUrl+'info/checkmember',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return compute(checkerMemberFromJson,response.body);
      } else {
        throw Exception('Failed to load cek versi');
      }
    }
    catch(e){
      return 'gagal';
    }
  }

}
