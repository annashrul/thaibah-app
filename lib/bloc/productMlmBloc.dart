import 'package:thaibah/Model/MLM/listCartModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/productMlmDetailModel.dart';
import 'package:thaibah/Model/productMlmModel.dart';
import 'package:thaibah/Model/productMlmSuplemenModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class ProductMlmBloc extends BaseBloc<ProductMlmModel>{
  Observable<ProductMlmModel> get allProductMlm => fetcher.stream;
  fetchProductMlmList(var page,var limit) async {
    ProductMlmModel productMlm =  await repository.fetchAllProductMlm(page,limit);
    fetcher.sink.add(productMlm);
  }
}

class ProductMlmSuplemenBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ProductMlmSuplemenModel> _serviceController = new PublishSubject<ProductMlmSuplemenModel>();
  Observable<ProductMlmSuplemenModel> get allProductMlmSuplemen => _serviceController.stream;
  fetchProductMlmSuplemenList(var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      ProductMlmSuplemenModel productMlmSuplemen =  await repository.fetchAllProductMlmSuplemen(page,limit);
      _serviceController.sink.add(productMlmSuplemen);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}
class ProductMlmDetailSuplemenBloc extends BaseBloc<ProductMlmDetailModel>{
  Observable<ProductMlmDetailModel> get getDetailProduct => fetcher.stream;

  fetchDetailProductSuplemen(var id) async {
    ProductMlmDetailModel detail = await repository.fetchDetailProductMlmSuplemen(id);
    fetcher.sink.add(detail);
  }

}
class ProductMlmDetailKavlingBloc extends BaseBloc<ProductMlmDetailModel>{
  Observable<ProductMlmDetailModel> get getDetailProductKavling => fetcher.stream;

  fetchDetailProductKavling(var id) async {
    ProductMlmDetailModel detail = await repository.fetchDetailProductMlmKavling(id);
    fetcher.sink.add(detail);
  }

}
class ProductCheckout extends BaseBloc<General> {
  Observable<General> get getResult => fetcher.stream;
  Future<General> fetchCheckout(String id,String price,String qty, String jasper, String ongkir) async =>  await repository.fetchCheckout(id, price, qty, jasper, ongkir);
  Future fetchCheckoutSuplemen(var id,var price,var qty,  var nama, var pekerjaan, var alamat, var ktp, var kk, var npwp, var telp) async =>  await repository.fetchCheckoutSuplemen(id, price, qty,nama, pekerjaan, alamat, ktp, kk,npwp, telp);
}
//class ProductCheckoutCart extends BaseBloc<General> {
//  Observable<General> get getResult => fetcher.stream;
//  Future<General> fetchCheckoutCart(var total,var jasper,var ongkir, var alamat) async =>  await repository.fetchCheckoutCart(total, jasper, ongkir, alamat);
//}

class ListCartBloc extends BaseBloc {
  final PublishSubject<ListCartModel> _serviceController = new PublishSubject<ListCartModel>();
  Observable<ListCartModel> get getResult => _serviceController.stream;
  bool _isDisposed = false;
  fetchListCart() async {
    if(_isDisposed) {
      print('false');
    }else{
      ListCartModel listCart =  await repository.fetchListCart();
      _serviceController.sink.add(listCart);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}
//
//class ChekcoutSuplemenBloc extends BaseBloc {
//  Observable get getResult => fetcher.stream;
//  Future fetchCheckoutSuplemen(var total,var jasper,var ongkir, var alamat, var type_alamat) async =>  await repository.fetchCheckoutCart(total, jasper, ongkir, alamat,type_alamat);
//  void dispose() {
//    fetcher.close();
//  }
//}

final productMlmBloc = ProductMlmBloc();
final productMlmSuplemenBloc = ProductMlmSuplemenBloc();
final productMlmDetailSuplemenBloc = ProductMlmDetailSuplemenBloc();
final productMlmDetailKavlingBloc = ProductMlmDetailKavlingBloc();
final productCheckoutBloc = ProductCheckout();
//final productCheckoutCart = ProductCheckoutCart();
final listCartBloc = ListCartBloc();
//final chekcoutSuplemenBloc = ChekcoutSuplemenBloc();
//final deleteCart = DeleteCart();
