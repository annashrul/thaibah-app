import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/downlineModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class DownlineProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<DownlineModel> fetchDownline() async{
    final token = await userRepository.getToken();
    final referral = await userRepository.getReff();
    final response = await client.get(
      ApiService().baseUrl+'member/jaringan/$referral?ismobile=ya',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("##################################################### INDEX DOWNLINE ###############################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(downlineModelFromJson,response.body);
    } else {
      throw Exception('Failed to load downline');
    }
  }

  Future<DownlineModel> fetchDetailDownline(var kdReff) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'member/jaringan/$kdReff?ismobile=ya',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("##################################################### DETAIL DOWNLINE ###############################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(downlineModelFromJson,response.body);
    } else {
      throw Exception('Failed to load downline');
    }
  }


}
