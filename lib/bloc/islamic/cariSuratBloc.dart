//import 'package:thaibah/Model/address/getAddressModel.dart';
//import 'package:thaibah/Model/address/getListAddressModel.dart';
//import 'package:thaibah/Model/islamic/cariSuratModel.dart';
//import 'package:thaibah/Model/islamic/checkedModel.dart';
//import 'package:thaibah/bloc/base.dart';
//import 'package:rxdart/rxdart.dart';
//
//class CariSuratBloc extends BaseBloc{
//  bool _isDisposed = false;
//  final PublishSubject<CariSuratModel> _serviceController = new PublishSubject<CariSuratModel>();
//  Observable<CariSuratModel> get getResult => _serviceController.stream;
//  fetchCariSurat(var param) async {
//    if(_isDisposed) {
//      print('false');
//    }else{
//      CariSuratModel cariSurat =  await repository.fetchCariSurat(param);
//      _serviceController.sink.add(cariSurat);
//    }
//  }
//  void dispose() {
//    _serviceController.close();
//    _isDisposed = true;
//  }
//
//}
//
//
////class CheckFavBloc extends BaseBloc{
////  bool _isDisposed = false;
////  final PublishSubject<CheckFavModel> _serviceController = new PublishSubject<CheckFavModel>();
////  Observable<CheckFavModel> get getResult => _serviceController.stream;
////  fetchCheckFav(var param) async {
////    if(_isDisposed) {
////      print('false');
////    }else{
////      CheckFavModel checkfav =  await repository.fetchCheckFav(param);
////      _serviceController.sink.add(checkfav);
////    }
////  }
////  void dispose() {
////    _serviceController.close();
////    _isDisposed = true;
////  }
////
////}
//
//
//final cariSuratBloc = CariSuratBloc();
////final checkFavBloc  = CheckFavBloc();