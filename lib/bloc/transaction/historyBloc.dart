import 'package:thaibah/Model/historyModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
//
//class HistoryBloc extends BaseBloc<HistoryModel>{
//  Observable<HistoryModel> get getResult => fetcher.stream;
//  fetchHistoryList(var param, var page, var limit,var from,var to, var q) async {
//    HistoryModel history =  await repository.fetchHistory(param, page, limit, from, to, q);
//    fetcher.sink.add(history);
//  }
//}



class HistoryBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<HistoryModel> _serviceController = new PublishSubject<HistoryModel>();
  Observable<HistoryModel> get getResult => _serviceController.stream;
  fetchHistoryList(var param, var page, var limit,var from,var to, var q) async {
    if(_isDisposed) {
      print('false');
    }else{
      HistoryModel history =  await repository.fetchHistory(param, page, limit, from, to, q);
      _serviceController.sink.add(history);
    }
  }

  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}



final historyBloc     = HistoryBloc();
