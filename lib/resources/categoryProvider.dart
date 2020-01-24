import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class CategoryProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future<CategoryModel> fetchCategory() async{
    final token = await userRepository.getToken();
    final response = await client.get(
      ApiService().baseUrl+'category?type=berita',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print("###########################################################KATEGORI###############################################################");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(categoryModelFromJson,response.body);
    } else {
      throw Exception('Failed to load category');
    }
  }


}
