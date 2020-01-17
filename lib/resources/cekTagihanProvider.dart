import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/cekTagihanModel.dart';

import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class CekTagihanProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<CekTagihanModel> fetchCekTagihan(String code,String no, String idpelanggan) async {
    final token = await userRepository.getToken();
    return await client.post(ApiService().baseUrl+"ppob/pasca/cektagihan",
        headers: {'Authorization': token},
        body: {
          "code":"$code",
          "no":"$no",
          "idpelanggan":"$idpelanggan"
        }).then((Response response) {
      var results = CekTagihanModel.fromJson(json.decode(response.body));
      return results;
    });
  }
}
