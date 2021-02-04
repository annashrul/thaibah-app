import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/Model/address/getAddressModel.dart';
import 'package:thaibah/Model/address/getListAddressModel.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class AddressProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future cekAlamat() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.post(
        ApiService().baseUrl+'transaction/checkout/detail',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"},
      body: {}
    );
    print(response.statusCode);
    print(response.body);
    var results;
    if (response.statusCode == 200) {
      results = GetDetailChekoutSuplemenModel.fromJson(json.decode(response.body));
//      results =  compute(addressModelFromJson,response.body);
    } else if(response.statusCode == 400) {
      results = General.fromJson(json.decode(response.body));
    }
    return results;
  }

  Future<AddressModel> fetchAlamat() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'member/addr/list',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
    );
    print(response.statusCode);
    print(response.body);
    var results;
    if (response.statusCode == 200) {
      return compute(addressModelFromJson,response.body);
    } else{
    throw Exception('Failed to load get address');
    }
//    return results;
  }

  Future<GetAddressModel> fetchGetAddress(var id) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'id',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
      return compute(getAddressModelFromJson,response.body);
    } else {
      throw Exception('Failed to load get address');
    }
  }

  Future fetchDeleteAddress(var id) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
      ApiService().baseUrl+"member/addr/delete",
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"},
      body: {
        "id":"$id",
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

  Future fetchUpdateMyBank(var title,var name,var main_address,var kd_prov,var kd_kota, var kd_kec, var no_hp, var id) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
      ApiService().baseUrl+"member/addr/update",
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"},
      body: {
        "title":"$title",
        "name":"$name",
        "main_address":"$main_address",
        "kd_prov":"$kd_prov",
        "kd_kota":"$kd_kota",
        "kd_kec":"$kd_kec",
        "no_hp":"$no_hp",
        "id":"$id",
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


  Future fetchCreateAddress(var title,var name,var main_address,var kd_prov,var kd_kota, var kd_kec, var no_hp) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
      ApiService().baseUrl+"member/addr/create",
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"},
      body: {
        "title":"$title",
        "name":"$name",
        "main_address":"$main_address",
        "kd_prov":"$kd_prov",
        "kd_kota":"$kd_kota",
        "kd_kec":"$kd_kec",
        "no_hp":"$no_hp",
      }).then((Response response) {
      var results;
      print(response.body);
      if(response.statusCode == 200){
        results =  GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
//      print(results.status);
      return results;
    });
  }

}
