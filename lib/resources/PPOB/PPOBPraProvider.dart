import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/Model/checkoutPPOBModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class PpobPraProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<PpobPraModel> fetchPpobPra(String type,var nohp) async{
    final token = await userRepository.getDataUser('token');
    var _url;
    var spl = type.split("|");
    if(type == 'E_MONEY' && nohp==''){
      _url = 'ppob/get/E_MONEY/list';
    }else{
      if(spl[0] == 'emoney'){
        _url = 'ppob/get/E_MONEY/$nohp?provider='+spl[1];
      }else{
        _url = 'ppob/get/$type/$nohp';
      }
    }
    print(_url);
    final response = await client.get(
      ApiService().baseUrl+_url,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(ppobPraModelFromJson, response.body);
    } else {
      throw Exception('Failed to load $type');
    }
  }

  Future fetchChekoutPPOBPra(var no,var code,var price,var charge,var idpelanggan) async {
    final token = await userRepository.getDataUser('token');
    final pin = await userRepository.getDataUser('pin');
//    try{
//      final response = await client.post(
//          ApiService().baseUrl+'ppob/pra/checkout',
//          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
//          body: {"no":"$no","code":"$code","price":"$price","charge":"$charge","pin":"$pin","idpelanggan":idpelanggan}
//      ).timeout(Duration(seconds: 60));
//      if (response.statusCode == 200) {
//        return CheckoutPpobModel.fromJson(json.decode(response.body));
//      } else {
//        return General.fromJson(json.decode(response.body));
//      }
//    } catch(e){
//      return 'gagal';
//    }

    try{
      final response = await client.post(
          ApiService().baseUrl+'ppob/pra/checkout',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
          body: {"no":"$no","code":"$code","price":"$price","charge":"$charge","pin":"$pin","idpelanggan":idpelanggan}
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return CheckoutPpobModel.fromJson(json.decode(response.body));
      } else {
        return General.fromJson(json.decode(response.body));
      }
    }on TimeoutException catch (e) {
      print('Timeout $e');
      return 'gagal';
    } on Error catch (e) {
      print('Error: $e');
      return 'error';
    }

//    return await client.post(ApiService().baseUrl+"ppob/pra/checkout",
//      headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
//      body: {"no":"$no","code":"$code","price":"$price","charge":"$charge","pin":"$pin","idpelanggan":idpelanggan}
//    ).then((Response response) {
//      var results;
//      print(response.statusCode);
//      if(response.statusCode == 200){
//        results = CheckoutPpobModel.fromJson(json.decode(response.body));
//      }else if(response.statusCode == 400){
//        results =  General.fromJson(json.decode(response.body));
//      }
//      return results;
//    });
  }

}
