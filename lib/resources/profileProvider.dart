import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class ProfileProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future fetchProfile() async{
    final token = await userRepository.getDataUser('token');
    try{
      final response = await client.get(
          ApiService().baseUrl+'member/myprofile',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        return compute(profileModelFromJson,response.body);
      }
      else if(response.statusCode == 400){
        final jsonResponse = json.decode(response.body);
        if(jsonResponse['name']=='TokenExpiredError'){
          return 'TokenExpiredError';
        }
      }
      else {
        throw Exception('Failed to load profile');
      }
    } on TimeoutException catch (_) {
      print('TimeoutException');
      return 'TimeoutException';
    } on SocketException catch (_) {
      print('SocketException');
      return 'SocketException';
    }
  }
}
