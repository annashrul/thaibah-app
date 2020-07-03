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
    final token = await userRepository.getDataUser('token');
    var url;
    if(param == 'mainTrx'){
      url = 'transaction/myhistory?type=master&page=$page&limit=$limit&datefrom=$from&dateto=$to&q=$q';
    }
    if(param == 'bonus'){
      url = 'transaction/myhistory?type=bonus&page=$page&limit=$limit&datefrom=$from&dateto=$to&q=$q';
    }
    if(param == 'voucher'){
      url = 'transaction/myhistory?type=voucher&page=$page&limit=$limit&datefrom=$from&dateto=$to&q=$q';
    }
    if(param == 'platinum'){
      url = 'transaction/myhistory?type=platinum&page=$page&limit=$limit&datefrom=$from&dateto=$to&q=$q';
    }
    print(param);
    print(url);
    final response = await client.get(
      ApiService().baseUrl+url,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return compute(historyModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history');
    }
  }

}
