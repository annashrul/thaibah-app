import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/transferDetailModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class TransferProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<GeneralInsertId> transfer(var saldo,var referral_penerima,var pesan) async {
    final pin = await userRepository.getDataUser('pin');
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"transaction/transfer",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "saldo":"$saldo",
          "referral_penerima":"$referral_penerima",
          "pesan":"$pesan",
          "pin":"$pin"
        }).then((Response response) {
      var results = GeneralInsertId.fromJson(json.decode(response.body));
      return results;
    });
  }

  Future transferDetail(var nominal,var referral_penerima,var pesan) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"transaction/transfer/detail",
      headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
      body: {
        "nominal":"$nominal",
        "referral_penerima":"$referral_penerima",
        "pesan":"$pesan",
      }).then((Response response) {
        var result;
        if(response.statusCode == 200){
          result = TransferDetailModel.fromJson(jsonDecode(response.body));
        }else if(response.statusCode == 400){
          result =  General.fromJson(json.decode(response.body));
        }
      return result;
    });
  }

  Future transferBonus(var saldo) async {
    final pin = await userRepository.getDataUser('pin');
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"transaction/transfer/bonus",
      headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
      body: {
        "saldo":"$saldo",
        "pin":"$pin"
      }
    ).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results =  GeneralInsertId.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }


}
