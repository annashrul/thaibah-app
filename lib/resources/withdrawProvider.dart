import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/historyPenarikanModel.dart';
import 'package:thaibah/Model/penarikan/penarikanDetailModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class WithdrawProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future withdraw(var amount,var id_bank) async {
    final pin = await userRepository.getDataUser('pin');
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"transaction/withdraw/create",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "amount":"$amount",
          "id_bank":"$id_bank",
          "pin":"$pin"
        }).then((Response response) {
          print(response.body);
      var results;
      if(response.statusCode==200){
        results = PenarikanDetailModel.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }

  Future cancelWithdraw(var id) async {
    final pin = await userRepository.getDataUser('pin');
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"transaction/withdraw/approve",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id_withdraw":"$id",
          "status":'2',
        }).then((Response response) {
      print(response.body);
      var results;
      if(response.statusCode==200){
        results = General.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results = General.fromJson(json.decode(response.body));
      }
      return results;
    });
  }

  Future<HistoryPenarikanModel> fetchHistoryPenarikan(var page, var limit, var from, var to) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'transaction/withdraw/list?page=$page&limit=$limit&datefrom=$from&dateto=$to',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("################################################ HISTORY PENARIKAN #######################################");
    print('transaction/withdraw/list?page=$page&limit=$limit&datefrom=$from&dateto=$to');
    if (response.statusCode == 200) {
      return compute(historyPenarikanModelFromJson,response.body);
    } else {
      throw Exception('Failed to load History Penarikan');
    }
  }


}
