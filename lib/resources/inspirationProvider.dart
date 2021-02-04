import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/inspirationModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class InspirationProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<InspirationModel> fetchInspiration(var page, var limit) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'info/inspiration?page=$page&limit=$limit',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("######################################## INSPIRASI #################################");
    print('info/inspiration?page=$page&limit=$limit');
    print(response.body);
    if (response.statusCode == 200) {
      return compute(inspirationModelFromJson,response.body);
    } else {
      throw Exception('Failed to load inpirations');
    }
  }


}
