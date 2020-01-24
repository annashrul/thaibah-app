import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/profileModel.dart';

import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class ProfileProvider {
  Client client = Client();
  final userRepository = UserRepository();
  Future<ProfileModel> fetchProfile() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'member/myprofile',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(profileModelFromJson,response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
