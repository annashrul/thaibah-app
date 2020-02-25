import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listDetailSosmedModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class SosmedProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ListSosmedModel> fetchListSosmed(var page,var limit) async{
    final token = await userRepository.getToken();
    final response = await client.get(
        ApiService().baseUrl+'socmed?page=$page&limit=$limit',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################Sosial Media###############################################################");
    print('socmed?page=$page&limit=$limit');
    print(response.body);
    if (response.statusCode == 200) {
      return compute(listSosmedModelFromJson,response.body);
    } else {
      throw Exception('Failed to load list sosmed');
    }
  }

  Future<ListSosmedModel> fetchListInboxSosmed(var page,var limit) async{
    final token = await userRepository.getToken();
    final response = await client.get(
        ApiService().baseUrl+'socmed?page=$page&limit=$limit',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################Sosial Media###############################################################");
    print('socmed?page=$page&limit=$limit');
    print(response.body);
    if (response.statusCode == 200) {
      return compute(listSosmedModelFromJson,response.body);
    } else {
      throw Exception('Failed to load list sosmed');
    }
  }

  Future<ListDetailSosmedModel> fetchListDetailSosmed(var id) async{
    final token = await userRepository.getToken();
    final response = await client.get(
        ApiService().baseUrl+'socmed/get/$id',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################Detail Sosial Media###############################################################");

    print(response.body);
    if (response.statusCode == 200) {
      return compute(listDetailSosmedModelFromJson,response.body);
    } else {
      throw Exception('Failed to load list detail sosmed');
    }
  }



  Future sendComment(var id,var caption) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"socmed/comment",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "caption":"$caption",
          "id_content":"$id",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results = GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }
  Future sendLike(var id) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"socmed/like",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id_content":"$id",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results = GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

  Future sendUnLike(var id) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"socmed/like",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id_content":"$id",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results =  General.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

  Future sendFeed(var caption,var picture) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"socmed/create",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "caption":"$caption",
          "picture":"$picture",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results = GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

  Future deleteFeed(var id) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"socmed/delete",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id":"$id",
        }).then((Response response) {
      var results;
      print(response.statusCode);
      if(response.statusCode == 200){
        results = General.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

}


