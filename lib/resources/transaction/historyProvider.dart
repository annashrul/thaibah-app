import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/historyModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class HistoryProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<HistoryModel> fetchHistory(var param, var page,var limit,var from,var to, var q) async{
    final token = await userRepository.getToken();
    var url;
    if(param == 'mainTrx'){
      url = 'transaction/myhistory?type=master&page=$page&limit=$limit&datefrom=$from&dateto=$to&q=$q';
    }
    if(param == 'bonus'){
      url = 'transaction/myhistory?type=bonus&page=$page&limit=$limit&datefrom=$from&dateto=$to&q=$q';
    }
    print(url);
    final response = await client.get(ApiService().baseUrl+url,headers: {'Authorization':token});
    print(response.statusCode);
    if (response.statusCode == 200) {
      return compute(historyModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history');
    }
  }

}
