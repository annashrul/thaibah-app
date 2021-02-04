import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class PrayerProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<PrayerModel> fetchPrayer(var long,var lat) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'islamic/jadwalsholat?long=$long&lat=$lat',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(prayerModelFromJson,response.body);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

}
