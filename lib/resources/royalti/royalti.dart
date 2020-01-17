import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/royalti/levelModel.dart';
import 'package:thaibah/Model/royalti/royaltiMemberModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class RoyaltiLevelProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<LevelModel> fetchLevel() async{
    final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'transaction/royalti/level',headers: {'Authorization':token});
    print("###########################################################ROYALTI LEVEL###############################################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(levelModelFromJson,response.body);
    } else {
      throw Exception('Failed to load level');
    }
  }


  Future<RoyaltiMemberModel> fetchRoyaltiMember(var param) async{
    final token = await userRepository.getToken();
    var level;
    if(param == 'kosong'){
      level = 'DIRHAM';
    }else{
      level = param;
    }
    final response = await client.get(ApiService().baseUrl+'transaction/royalti/member/$level',headers: {'Authorization':token});
    print("###########################################################ROYALTI MEMBER###############################################################");
    print(response.body);
    print(param);
    var results;
    if (response.statusCode == 200) {
      return compute(royaltiMemberModelFromJson,response.body);
    }else {
      throw Exception('Failed to load level');
    }
//    return results;

  }

}


