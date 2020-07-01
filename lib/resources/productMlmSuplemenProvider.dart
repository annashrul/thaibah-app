import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/Model/MLM/listCartModel.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/productMlmDetailModel.dart';
import 'package:thaibah/Model/productMlmSuplemenModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class ProductMlmSuplemenProvider {
  Client client = Client();
  final userRepository = UserRepository();

  Future fetchProductMlmSuplemen(var page, var limit) async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
        ApiService().baseUrl+'product/mlm?page=$page&limit=$limit&category=suplemen',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    ).timeout(Duration(microseconds: ApiService().timerActivity));
		try{
      print("########################### PRODUK SUPLEMEN ############################");
      print(response.body);
      print('product/mlm?page=$page&limit=$limit&category=suplemen');
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return compute(productMlmSuplemenModelFromJson, response.body);
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load product suplemen');
      }
    }catch(e){
      return compute(generalFromJson, response.body);
    }
	}

  Future<ProductMlmDetailModel> fetchProductDetailMlm(String id) async{
		final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'product/mlm/get/'+id,
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if(response.statusCode == 200){
      return compute(productMlmDetailModelFromJson, response.body);
    }else{
      throw Exception('failed to load product mlm by id');
    }
  }



  Future fetchCheckoutSuplemen(var id,var price,var qty,var nama,var pekerjaan,var alamat,var ktp,var kk,var npwp,var telp) async {
		final pin = await userRepository.getDataUser('pin');
		final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"transaction/checkout/tanah",
      headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
      body: {
        "id_product":"$id",
        "price":"$price",
        "qty":"$qty",
        "nama":"$nama",
        "pekerjaan":"$pekerjaan",
        "alamat":"$alamat",
        "ktp":"$ktp",
        "kk":"$kk",
        "npwp":"$npwp",
        "pin": "$pin",
        "nohp": "$telp"
      }).then((Response response) {
        print(response.body);
      return General.fromJson(json.decode(response.body));
    });
  }


  Future<ListCartModel> fetchListCart() async{
    final token = await userRepository.getDataUser('token');
    final response = await client.get(
      ApiService().baseUrl+'product/mlm/listcart',
      headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    print(response.body);
    if (response.statusCode == 200) {
      return compute(listCartModelFromJson, response.body);
    }
//    else{
//      throw Exception('Failed to load product suplemen');
//    }
  }

  Future<General> addProduct(var id,var price,var qty,var weight) async{
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"product/mlm/addtocart",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id_product":"$id",
          "price":"$price",
          "qty":"$qty",
          "weight":weight
        }).then((Response response) {
      print(response.body);
      return General.fromJson(json.decode(response.body));
    });
  }

  Future<General> updateProduct(var id,var qty) async{
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"product/mlm/updateqty",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id":"$id",
          "qty":"$qty",
        }).then((Response response) {
      print(response.body);
      return General.fromJson(json.decode(response.body));
    });
  }
  Future<General> deleteProduct(var id) async{
    final token = await userRepository.getDataUser('token');
    return await client.post(ApiService().baseUrl+"product/mlm/deletecart",
        headers: {'Authorization': token,'username':ApiService().username,'password':ApiService().password},
        body: {
          "id":"$id",
        }).then((Response response) {
      print(response.body);
      return General.fromJson(json.decode(response.body));
    });
  }


}
