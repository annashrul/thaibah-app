import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/config/api.dart';

class GagalHitProvider {
  Client client = Client();
  Future<General> fetchRequest(var modul,var device) async{
    final response = await client.get(
        ApiService().baseUrl+'info/notif/$modul?device=$device',
    );
    if (response.statusCode == 200) {
      return compute(generalFromJson,response.body);
    } else {
      throw Exception('Failed to send notif');
    }
  }
}