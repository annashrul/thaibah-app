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
    var url='transaction/myhistory?type=$param&page=$page&limit=$limit&datefrom=$from&dateto=$to';
    if(q!=''){
      url+='&q=$q';
    }

    print(param);
    print(url);
    final response = await client.get(
      ApiService().baseUrl+url,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return compute(historyModelFromJson,response.body);
    } else {
      throw Exception('Failed to load history');
    }
  }

}
