import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/detailNewsPerCategoryModel.dart';
import 'package:thaibah/Model/newsDetailModel.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class NewsProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<NewsModel> fetchNews(var page,var limit,var param) async{
		final token = await userRepository.getDataUser('token');
		String url = ApiService().baseUrl+'berita?page=$page&limit=$limit';
		if(param!=''){
		  url+='&category=$param';
    }
    final response = await client.get(
      url,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(newsModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }

  Future<NewsDetailModel> fetchDetailNews(String id) async{
		final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'berita/get/'+id,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(newsDetailModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }


  Future<NewsModel> fetchHomeNews(String title) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'berita?category='+title,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (response.statusCode == 200) {
      return compute(newsModelFromJson,response.body);
    } else {
      throw Exception('Failed to load promosi');
    }
  }

  Future<DetailNewsPerCategoryModel> fetchDetailNewsPerCategory(var page,var limit,var title) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'berita?page=$page&limit=$limit&category='+title,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################DETAIL NESW PER CATEGORY###############################################################");
    print("########################'berita?berita?page=$page&limit=$limit&category=$title###########################");
    print(response.body);
    if(response.statusCode == 200){
      return compute(detailNewsPerCategoryModelFromJson, response.body);
    }else{
      throw Exception('Failed to load news');
    }
  }


}
