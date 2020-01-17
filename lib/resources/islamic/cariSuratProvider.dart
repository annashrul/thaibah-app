//import 'dart:async';
//import 'dart:convert';
//import 'package:flutter/foundation.dart';
//import 'package:http/http.dart' show Client, Response;
//import 'package:thaibah/Model/generalModel.dart';
//import 'package:thaibah/Model/islamic/cariSuratModel.dart';
//import 'package:thaibah/Model/islamic/checkedModel.dart';
//import 'package:thaibah/config/api.dart';
//import 'package:thaibah/config/user_repo.dart';
//
//class CariSuratProvider {
//  Client client = Client();
//  final userRepository = UserRepository();
//  Future<CariSuratModel> fetchCariSurat(var param) async{
//    final token = await userRepository.getToken();
//    final response = await client.get(ApiService().baseUrl+'islamic/carisurat?q=$param',headers: {'Authorization':token});
//    print("###################################### CARI SURAT ################################");
//    print(response.body);
//    if (response.statusCode == 200) {
//      return compute(cariSuratModelFromJson,response.body);
//    } else {
//      throw Exception('Failed to load cari surat');
//    }
//  }
//
//  Future fetchChecked(var id) async {
//    final token = await userRepository.getToken();
//    return await client.post(ApiService().baseUrl+"islamic/myquran/checked/set",headers: {'Authorization':token},
//        body: {
//          "id_ayat":"$id",
//        }).then((Response response) {
//      var results;
//      if(response.statusCode == 200){
//        results =  General.fromJson(json.decode(response.body));
//      }else if(response.statusCode == 400){
//        results =  General.fromJson(json.decode(response.body));
//      }
//      print(results.status);
//      return results;
//    });
//  }
//  Future fetchFavorite(var id) async {
//    final token = await userRepository.getToken();
//    return await client.post(ApiService().baseUrl+"islamic/myquran/fav/set",headers: {'Authorization':token},
//        body: {
//          "id_ayat":"$id",
//        }).then((Response response) {
//      var results;
//      if(response.statusCode == 200){
//        results =  General.fromJson(json.decode(response.body));
//      }else if(response.statusCode == 400){
//        results =  General.fromJson(json.decode(response.body));
//      }
//      print(results.status);
//      return results;
//    });
//  }
//
//  Future<CheckFavModel> fetchCheckFav(var param) async{
//    final token = await userRepository.getToken();
//    final response = await client.get(ApiService().baseUrl+'islamic/myquran/$param',headers: {'Authorization':token});
//    print("###################################### CHECKED & FAVORITE ################################");
//    print(response.body);
//    if (response.statusCode == 200) {
//      return compute(checkFavModelFromJson,response.body);
//    } else {
//      throw Exception('Failed to load checked favorite');
//    }
//  }
//
//
//}
//
//
//
