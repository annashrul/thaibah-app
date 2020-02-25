import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/MLM/detailHistoryPembelianSuplemen.dart';
import 'package:thaibah/Model/MLM/resiModel.dart';
import 'package:thaibah/Model/detailHistoryPPOBModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/historyPPOBModel.dart';
import 'package:thaibah/Model/historyPembelianSuplemen.dart';
import 'package:thaibah/Model/historyPembelianTanahModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class HistoryPembelianProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<HistoryPembelianTanahModel> fetchHistoryPembelianTanah(var page, var limit, var from, var to) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'pembelian/tanah?page=$page&limit=$limit&datefrom=$from&dateto=$to',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(historyPembelianTanahModelFromJson,response.body);
    } else {
      throw Exception('Failed to load History Pembelian Tanah');
    }
  }

  Future<HistoryPembelianSuplemenModel> fetchHistoryPembelianSuplemen(var page,var limit, var from, var to) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'pembelian/suplemen?page=$page&limit=$limit&datefrom=$from&dateto=$to',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("####################################### HISTORY PEMBELIAN SUPLEMEN #######################################");
    print(response.body);
    print('pembelian/suplemen?page=$page&limit=$limit&datefrom=$from&dateto=$to');

    if (response.statusCode == 200) {
      return compute(historyPembelianSuplemenModelFromJson,response.body);
    } else {
      throw Exception('Failed to load History Pembelian Suplemen');
    }
  }

  Future<HistoryPpobModel> fetchHistoryPPOB(var page, var limit, var from, var to) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'pembelian/ppob?page=$page&limit=$limit&datefrom=$from&dateto=$to',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("####################################### HISTORY PEMBELIAN PPOB #######################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(historyPpobModelFromJson,response.body);
    } else {
      throw Exception('Failed to load History Pembelian PPOB');
    }
  }

  Future<DetailHistoryPpobModel> fetchDetailHistoryPPOB(var kdTrx) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'ppob/cektrx/$kdTrx',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(detailHistoryPpobModelFromJson,response.body);
    } else {
      throw Exception('Failed to load History Pembelian PPOB');
    }
  }


  Future<DetailHistoryPembelianSuplemenModel> fetchdetailHistoryPembelianSuplemen(var id) async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'pembelian/suplemen/get/$id',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("####################################### DETAIL HISTORY PEMBELIAN SUPLEMEN #######################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(detailHistoryPembelianSuplemenModelFromJson,response.body);
    } else {
      throw Exception('Failed to load detail History Pembelian Suplemen');
    }
  }

  Future fetchResi(var resi, var kurir) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"ongkir/cekResi",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "resi":"$resi",
          "kurir":"$kurir",
        }).then((Response response) {
      var results;
      print(response.body);
      if(response.statusCode == 200){
        results = ResiModel.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }

  Future fetchConfirm(var id) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"pembelian/konfirmasi",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id":"$id",
        }).then((Response response) {
      var results;
      print(response.body);
      if(response.statusCode == 200){
        results = General.fromJson(json.decode(response.body));
      }else{
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }


}
