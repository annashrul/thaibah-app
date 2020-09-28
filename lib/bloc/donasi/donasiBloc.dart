import 'package:thaibah/Model/donasi/detailDonasiModel.dart';
import 'package:thaibah/Model/donasi/historyDonasiModel.dart';
import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';


class LisDonasiBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ListDonasiModel> _serviceController = new PublishSubject<ListDonasiModel>();
  Observable<ListDonasiModel> get getResult => _serviceController.stream;
  fetchListDonasi(var where) async {
    if(_isDisposed) {
      print('false');
    }else{
      ListDonasiModel history =  await repository.fetchListDonasi(where);
      _serviceController.sink.add(history);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class DetailDonasiBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<DetailDonasiModel> _serviceController = new PublishSubject<DetailDonasiModel>();
  Observable<DetailDonasiModel> get getResult => _serviceController.stream;
  fetchDetailDonasi(var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      DetailDonasiModel history =  await repository.fetchDetailDonasi(id);
      _serviceController.sink.add(history);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class HistoryDonasiBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<HistoryDonasiModel> _serviceController = new PublishSubject<HistoryDonasiModel>();
  Observable<HistoryDonasiModel> get getResult => _serviceController.stream;
  fetchHistoryDonasi(var where) async {
    if(_isDisposed) {
      print('false');
    }else{
      HistoryDonasiModel history =  await repository.fetchHistoryDonasi(where);
      _serviceController.sink.add(history);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}


final listDonasiBloc    = LisDonasiBloc();
final detailDonasiBloc    = DetailDonasiBloc();
final historyDonasiBloc    = HistoryDonasiBloc();
