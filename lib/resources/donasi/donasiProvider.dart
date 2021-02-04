import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client,Response;
import 'package:thaibah/Model/donasi/checkoutDonasiModel.dart';
import 'package:thaibah/Model/donasi/detailDonasiModel.dart';
import 'package:thaibah/Model/donasi/historyDonasiModel.dart';
import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/Model/generalModel.dart';
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
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
    );
    print("DONASI ${response.body}");
    if (response.statusCode == 200) {
      return compute(listDonasiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history deposit');
    }
  }

  Future<DetailDonasiModel> fetchDetailDonasi(var id) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
        ApiService().baseUrl+'donasi/get/$id',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("DONASI ${response.body}");
    if (response.statusCode == 200) {
      return compute(detailDonasiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history deposit');
    }
  }

  Future<HistoryDonasiModel> fetchHistoryDonasi(var where) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
        ApiService().baseUrl+'donasi/invoice?page=1$where',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("DONASI ${response.body}");
    if (response.statusCode == 200) {
      return compute(historyDonasiModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history deposit');
    }
  }



}

class CheckoutDonasiProvider{
  Client client = Client();
  final userRepository = UserRepository();
  Future checkoutDonasi(var id_donasi,var nominal,var anonim,var pesan,var bank_tujuan) async{
    print("$id_donasi, $nominal, $anonim, $pesan, $bank_tujuan");
    final token = await userRepository.getDataUser('token');
    final phone = await userRepository.getDataUser('phone');
    var results;
    try{
      final response = await client.post(
          ApiService().baseUrl+'donasi/checkout',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
          body: {
            "id_donasi":id_donasi,
            "nominal":nominal,
            "anonim":anonim,
            "nohp":phone,
            "pesan":pesan,
            "bank_tujuan":bank_tujuan,
          }
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        results = CheckoutDonasiModel.fromJson(json.decode(response.body));
      } else if(response.statusCode == 400) {
        results = General.fromJson(json.decode(response.body));
      }
    }on TimeoutException catch (_){
      results = 'TimeoutException';
    }
    return results;
  }

  Future uploadBuktiTransferDonasi(var id_inv,var bukti) async{
    final token = await userRepository.getDataUser('token');
    final phone = await userRepository.getDataUser('phone');
    var results;
    try{
      final response = await client.post(
          ApiService().baseUrl+'donasi/updatebukti',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
          body: {
            "id_inv":id_inv,
            "bukti":bukti,
          }
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        results = General.fromJson(json.decode(response.body));
      } else if(response.statusCode == 400) {
        results = General.fromJson(json.decode(response.body));
      }
    }on TimeoutException catch (_){
      results = 'TimeoutException';
    }
    return results;
  }

}
