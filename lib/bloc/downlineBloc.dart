import 'package:thaibah/Model/downlineModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
//
//class DownlineBloc extends BaseBloc<DownlineModel>{
//  Observable<DownlineModel> get allDownline => fetcher.stream;
//  fetchDownlineList() async {
//    DownlineModel downline =  await repository.fetchDownline();
//    fetcher.sink.add(downline);
//  }
//}

//class DetailDownlineBloc extends BaseBloc<DownlineModel>{
//  Observable<DownlineModel> get allDetailDownline => fetcher.stream;
//  fetchDetailDownlineList(var kdReff) async {
//    DownlineModel detailDownline =  await repository.fetchDetailDownline(kdReff);
//    fetcher.sink.add(detailDownline);
//  }
//}

class DownlineBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<DownlineModel> _serviceController = new PublishSubject<DownlineModel>();
  Observable<DownlineModel> get allDownline => _serviceController.stream;
  fetchDownlineList() async {
    if(_isDisposed) {
      print('false');
    }else{
      DownlineModel downline =  await repository.fetchDownline();
      _serviceController.sink.add(downline);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;

  }
}

class DetailDownlineBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<DownlineModel> _serviceController = new PublishSubject<DownlineModel>();
  Observable<DownlineModel> get allDetailDownline => _serviceController.stream;
  fetchDetailDownlineList(var kdReff) async {
    if(_isDisposed) {
      print('false');
    }else{
      DownlineModel detailDownline =  await repository.fetchDetailDownline(kdReff);
      _serviceController.sink.add(detailDownline);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;

  }
}



final downlineBloc  = DownlineBloc();
final detailDownlineBloc  = DetailDownlineBloc();
