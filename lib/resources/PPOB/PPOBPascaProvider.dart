import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/PPOB/PPOBPascaCekTagihanModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCheckoutModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class PpobPascaProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<PpobPascaModel> fetchPpobPasca(var type) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'ppob/pasca/get/$type',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(ppobPascaModelFromJson, response.body);
    } else {
      throw Exception('Failed to load $type');
    }
  }

  Future fetchPpobPascaCekTagihan(var code,var no,var idpelanggan) async {
    final token = await userRepository.getToken();
    final pin = await userRepository.getPin();
    return await client.post(
      ApiService().baseUrl+"ppob/pasca/cektagihan",
      headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
      body: {"code":"$code","no":"$no","idpelanggan":"$idpelanggan"}
    ).then((Response response) {
      var results;
      print(response.statusCode);
      if(response.statusCode == 200){
        results = PpobPascaCekTagihanModel.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }

  Future fetchPpobPascaCheckout(var code,var orderid,var price) async {
    final token = await userRepository.getToken();
    final pin = await userRepository.getPin();
    return await client.post(ApiService().baseUrl+"ppob/pasca/checkout",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {"code":"$code","orderid":"$orderid","price":"$price"}).then((Response response) {
      var results;
      print(response.statusCode);
      if(response.statusCode == 200){
        results = PpobPascaCheckoutModel.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }

}
