import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/address/getAddressModel.dart';
import 'package:thaibah/Model/address/getListAddressModel.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/islamic/categoryDoaModel.dart';
import 'package:thaibah/Model/islamic/nearbyMosqueModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class NearbyMosqueProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<NearbyMosqueModel> fetchNearbyMosque(var lat, var lng) async{
    final token = await userRepository.getToken();
    final response = await client.get(ApiService().baseUrl+'islamic/nearbymosque?lat=$lat&lng=$lng',headers: {'Authorization':token});
    if (response.statusCode == 200) {
      return compute(nearbyMosqueModelFromJson,response.body);
    } else {
      throw Exception('Failed to load nearby mosque');
    }
  }
}

