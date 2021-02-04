import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client,Response;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/virtualAccount/createAvailableVirtualBankModel.dart';
import 'package:thaibah/Model/virtualAccount/getAvailableVirtualBankModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class VirtualAccountProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<GetAvailableVirtualModel> fetchAvailableBank() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'transaction/virtual/available',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
      return compute(getAvailableVirtualModelFromJson,response.body);
    } else {
      throw Exception('Failed to load available bank');
    }
  }

  Future fetchCreateAvailableVirtualBank(var amount,var name,var bankcode) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
      ApiService().baseUrl+"transaction/virtual/create",
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password,"Content-Type": "application/json"},
      body: {
        "amount":"$amount",
        "name":"$name",
        "bankcode":"$bankcode",
      }).then((Response response) {
        var results;
        print(response.statusCode);
        if(response.statusCode == 200){
          results =  CreateAvailableVirtualModel.fromJson(json.decode(response.body));
        }else if(response.statusCode == 400){
          results =  General.fromJson(json.decode(response.body));
        }

        return results;
    });
  }

}
