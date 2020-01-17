import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client,Response;
import 'package:thaibah/Model/depositManual/detailDepositModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class DetailDepositProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<DetailDepositModel> fetchDetailDeposit(var id_bank,var amount) async {
    final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"transaction/deposit/create",
        headers: {'Authorization': token},
        body: {
          "id_bank":"$id_bank",
          "amount":"$amount",
        }).then((Response response) {
      var results = DetailDepositModel.fromJson(json.decode(response.body));
      return results;
    });
  }

  Future<General> fetchUploadBuktiTransfer(var id_deposit, var bukti) async {
    final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"transaction/deposit/bukti",headers: {'Authorization':token},
        body: {
          "id_deposit":"$id_deposit",
          "bukti":"$bukti",
        }).then((Response response) {
      return General.fromJson(json.decode(response.body));
    });
  }




}
