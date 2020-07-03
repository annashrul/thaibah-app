import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client,Response;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/islamic/ayatModel.dart';
import 'package:thaibah/Model/islamic/categoryDoaModel.dart';
import 'package:thaibah/Model/islamic/checkedModel.dart';
import 'package:thaibah/Model/islamic/doaModel.dart';
import 'package:thaibah/Model/islamic/kalenderHijriahModel.dart';
import 'package:thaibah/Model/islamic/subCategoryDoaModel.dart';
import 'package:thaibah/Model/suratModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class IslamicProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<SuratModel> fetchSurat() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'islamic/listsurat',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(suratModelFromJson,response.body);
    } else {
      throw Exception('Failed to load surat');
    }
  }

  Future<AyatModel> fetchAyat(var idSurat,var param,var page,var limit) async{
    final token = await userRepository.getDataUser('token');
    var url;
    if(param =='detail'){
      url = 'islamic/ayat/$idSurat?page=$page&limit=$limit';
    }else{
      url = 'islamic/ayat/1?page=$page&limit=$limit&q=$param';
    }

    print(url);
    final response = await client.get(
      ApiService().baseUrl+url,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(ayatModelFromJson,response.body);
    } else {
      throw Exception('Failed to load ayat');
    }
  }

  Future fetchActionPost(var id, var param) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
      ApiService().baseUrl+"islamic/myquran/$param/set",
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
      body: {
        "id_ayat":"$id",
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

  Future fetchNote(var id, var note) async {
    final token = await userRepository.getDataUser('token');
    return await client.post(
      ApiService().baseUrl+"islamic/myquran/note/set",
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password},
      body: {
        "id_ayat" : "$id",
        "note"    : "$note",
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

  Future<CheckFavModel> fetchCheckFav(var param) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'islamic/myquran/$param',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###################################### $param ################################");
    print('islamic/myquran/$param');
    print(response.body);
    if (response.statusCode == 200) {
      return compute(checkFavModelFromJson,response.body);
    } else {
      throw Exception('Failed to load $param');
    }
  }

  Future<CategoryDoaModel> fetchCategoryDoaHadist(var type) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'category?type=$type',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(categoryDoaModelFromJson,response.body);
    } else {
      throw Exception('Failed to load category $type');
    }
  }

  Future<SubCategoryDoaModel> fetchSubCategoryDoaHadist(var type,var id) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'category/sub?type=$type&id=$id',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(subCategoryDoaModelFromJson,response.body);
    } else {
      throw Exception('Failed to load category $id');
    }
  }

  Future<KalenderHijriahModel> fetchKalenderHijriah(var bln, var thn) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'islamic/hijriah?bln=$bln&thn=$thn',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("########################### KALENDER #############################");
    print('islamic/hijriah?bln=$bln&thn=$thn');
    if (response.statusCode == 200) {
      return compute(kalenderHijriahModelFromJson,response.body);
    } else {
      throw Exception('Failed to load calendar hijri');
    }
  }

  Future<DoaModel> fetchDoaHadist(var type, var id, var q) async{
    final token = await userRepository.getDataUser('token');
    var _url = q!='' ? 'islamic/$type?q=$q' : 'islamic/$type?id=$id';
    final response = await client.get(
      ApiService().baseUrl+_url,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("################################## $type ####################################");
    print(_url);
    if (response.statusCode == 200) {
      return compute(doaModelFromJson,response.body);
    } else {
      throw Exception('Failed to load $type');
    }
  }

}
