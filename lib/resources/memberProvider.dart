import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/createMemberModel.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/member/contactModel.dart';
import 'package:thaibah/Model/memberModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class MemberProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<MemberModel> fetchMember(var id) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'member/get/$id',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(memberModelFromJson,response.body);
    } else {
      throw Exception('Failed to load member');
    }
  }

  Future fetchCreateMember(var pin, var name,var ismobile,var no_hp, var referral/*, var ktp*/) async {
    return await client.post(ApiService().baseUrl+"auth/register",
      body: {
        "pin":"$pin",
        "name":"$name",
        "ismobile":"$ismobile",
        "no_hp":"$no_hp",
        "referral":"$referral",
        /*"ktp":"$ktp",*/
        "signup":"Android",
      }).then((Response response) {
        var results;
        if(response.statusCode == 200){
          results =  General.fromJson(json.decode(response.body));
        }else if(response.statusCode == 400){
          results =  General.fromJson(json.decode(response.body));
        }
      print(results.status);
      return results;
    });
  }

  Future resendOtp(var nohp,var referral,var type) async {
    var cek;
    if(type == 'update'){
      cek = '';
    }else{
      cek = referral;
    }
    return await client.post(ApiService().baseUrl+"auth/resendotp",
        body: {
          "nohp":"$nohp",
          "type":"$type",
          "referral":"$cek",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results =  ResendOtp.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }

  Future forgotPin() async {
    final nama = await userRepository.getDataUser('name');
    final nohp = await userRepository.getDataUser('phone');
    return await client.post(ApiService().baseUrl+"auth/resendotp",
        body: {
          "nohp":"$nohp",
          "type":"resend",
          "nama":"$nama",
        }).then((Response response) {
      var results;
      if(response.statusCode == 200){
        results =  ResendOtp.fromJson(json.decode(response.body));
      }else if(response.statusCode == 400){
        results =  General.fromJson(json.decode(response.body));
      }
      print(results.status);
      return results;
    });
  }


  Future fetchUpdateMember(var name,var no_hp, var gender,var picture, var cover, var ktp) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
        ApiService().baseUrl+"member/update",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "name":"$name",
          "no_hp":"$no_hp",
          "gender ":"$gender",
          "picture":"$picture",
          "cover":"$cover",
          "ktp":"$ktp",
        }).then((Response response) {
      return General.fromJson(json.decode(response.body));
    });
  }

  Future fetchUpdatePinMember(var pin) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
        ApiService().baseUrl+"member/update",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "pin":"$pin",
        }).then((Response response) {
          print("################################## UPDATE PIN ######################################");
          print(response.body);
      return General.fromJson(json.decode(response.body));
    });
  }

  Future<ContactModel> fetchContact() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'member/contact',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(contactModelFromJson,response.body);
    } else {
      throw Exception('Failed to load contact');
    }
  }


  Future<General> logout() async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
        ApiService().baseUrl+"auth/logout",
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
        body: {}).then((Response response) {
      return General.fromJson(json.decode(response.body));
    });
  }

}
