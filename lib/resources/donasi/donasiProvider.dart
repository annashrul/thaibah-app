import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client,Response;
import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class DonasiProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ListDonasiModel> fetchListDonasi(var where) async{
    print(ApiService().baseUrl+'donasi?page=1$where');
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
        ApiService().baseUrl+'donasi?page=1$where',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(listDonasiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history deposit');
    }
  }
}
