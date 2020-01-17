import 'package:thaibah/bloc/base.dart';
import 'package:thaibah/Model/promosiModel.dart';

import 'package:rxdart/rxdart.dart';
//
//class PromosiBloc extends BaseBloc<PromosiModel>{
//  Observable<PromosiModel> get allPromosi => fetcher.stream;
//  fetchPromosiList() async {
//    PromosiModel promosi =  await repository.fetchAllPromosi();
//    fetcher.sink.add(promosi);
//  }
//}
class PromosiBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<PromosiModel> _serviceController = new PublishSubject<PromosiModel>();
  Observable<PromosiModel> get allPromosi => _serviceController.stream;
  fetchPromosiList() async {
    if(_isDisposed) {
      print('false');
    }else{
      PromosiModel promosi =  await repository.fetchAllPromosi();
      _serviceController.sink.add(promosi);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class PromosiListBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<PromosiModel> _serviceController = new PublishSubject<PromosiModel>();
  Observable<PromosiModel> get allPromosiList => _serviceController.stream;
  fetchAllPromosiList(var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      PromosiModel promosi =  await repository.fetchAllListPromosi(page,limit);
      _serviceController.sink.add(promosi);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

//
//class PromosiListBloc extends BaseBloc<PromosiModel>{
//  Observable<PromosiModel> get allPromosiList => fetcher.stream;
//  fetchAllPromosiList() async {
//    PromosiModel promosi =  await repository.fetchAllListPromosi();
//    fetcher.sink.add(promosi);
//  }
//}

final promosiBloc = PromosiBloc();
final promosiListBloc = PromosiListBloc();