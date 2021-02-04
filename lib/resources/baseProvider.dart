import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class BaseProvider{
  Client client = Client();
  final userRepository = UserRepository();
  Future getProvider(url,param)async{
    try{
      final token= await userRepository.getDataUser('token');
      Map<String, String> head={'Authorization':token,'username': ApiService().username, 'password': ApiService().password,"Content-Type": "application/json"};
      final response = await client.get("${ApiService().baseUrl}$url", headers:head).timeout(Duration(seconds: ApiService().timerActivity));
      if (response.statusCode == 200) {
        return param(response.body);
      }else if(response.statusCode==400){
        final jsonResponse = json.decode(response.body);
        if(jsonResponse['name']==ApiService().tokenExpiredError){
          return ApiService().tokenExpiredError;
        }
      }
    }on TimeoutException catch (_) {
      print('TimeoutException');
      return ApiService().timeoutException;
    } on SocketException catch (_) {
      print('SocketException');
      return ApiService().socketException;
    }
  }





}
