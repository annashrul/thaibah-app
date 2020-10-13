import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
// import 'package:sqlite_at_runtime/sqlite_at_runtime.dart';

import 'package:thaibah/Model/promosiModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class PromosiProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<PromosiModel> fetchPromosi() async{
		final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'promosi?limit=5',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );

    if (response.statusCode == 200) {
      return compute(promosiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }


  Future<PromosiModel> fetchListPromosi(var page, var limit) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'promosi?page=$page&limit=$limit',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
//    await Sqlartime.insertIntoTable(
//        'tentang',
//        ['title','caption','link','picture','penulis','createdAt','thumbnail','default_id'],
//        [title,caption,link,picture,penulis,createdAt,thumbnail,defaultId]
//    );
//    print('promosi?page=$page&limit=$limit');
    print('RESPON SERVER $response');
    if (response.statusCode == 200) {
      return compute(promosiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }
}
