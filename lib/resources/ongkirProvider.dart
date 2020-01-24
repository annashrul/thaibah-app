import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/kecamatanModel.dart';
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/ongkirModel.dart';
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class OngkirProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ProvinsiModel> fetchProvinsi() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'ongkir/provinsi',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(provinsiModelFromJson, response.body);
    } else {
      throw Exception('Failed to load product mlm');
    }
  }
  
  Future<KotaModel> fetchKota(var idProv) async {
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'ongkir/kota/'+idProv,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    // print(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return compute(kotaModelFromJson, response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load product mlm');
    }
  }

  Future<KecamatanModel> fetchKecamatan(var idKota) async {
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'ongkir/kecamatan/'+idKota,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    // print(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return compute(kecamatanModelFromJson, response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load product mlm');
    }
  }


  Future<OngkirModel> fetchAllOngkir(var dari,var ke,var berat, var kurir) async {
    final token = await userRepository.getToken();
    return await client.post(
        ApiService().baseUrl+"ongkir/cekHarga",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          'dari':dari,
          'ke':ke,
          'berat':berat,
          'kurir':kurir,
        }).then((Response response) {
          print(response.body);
          var results = ongkirModelFromJson(response.body);
          return results;
    });
  }


}
