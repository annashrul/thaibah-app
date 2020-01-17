import 'package:thaibah/Model/MLM/detailHistoryPembelianSuplemen.dart';
import 'package:thaibah/Model/MLM/resiModel.dart';
import 'package:thaibah/Model/detailHistoryPPOBModel.dart';
import 'package:thaibah/Model/historyPPOBModel.dart';
import 'package:thaibah/Model/historyPembelianSuplemen.dart';
import 'package:thaibah/Model/historyPembelianTanahModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class HistoryPembelianTanahBloc extends BaseBloc<HistoryPembelianTanahModel>{
  Observable<HistoryPembelianTanahModel> get getResult => fetcher.stream;
  fetchHistoryPemblianTanahList(var page, var limit,var from, var to) async {
    HistoryPembelianTanahModel historyPembelianTanah =  await repository.fetchHistoryPembelianTanah(page,limit,from,to);
    fetcher.sink.add(historyPembelianTanah);
  }
}

class HistoryPembelianSuplemenBloc extends BaseBloc<HistoryPembelianSuplemenModel>{
  Observable<HistoryPembelianSuplemenModel> get getResult => fetcher.stream;
  fetchHistoryPemblianSuplemenList(var page, var limit, var from, var to) async {
    HistoryPembelianSuplemenModel historyPembelianSuplemen =  await repository.fetchHistoryPembelianSuplemen(page,limit,from,to);
    fetcher.sink.add(historyPembelianSuplemen);
  }
}


class HistoryPPPOBBloc extends BaseBloc<HistoryPpobModel>{
  Observable<HistoryPpobModel> get getResult => fetcher.stream;
  fetchHistoryPPOBList(var page, var limit, var from, var to) async {
    HistoryPpobModel historyPPOB =  await repository.fetchHistoryPPOB(page,limit, from, to);
    fetcher.sink.add(historyPPOB);
  }
}


class DetailHistoryPPPOBBloc extends BaseBloc<DetailHistoryPpobModel>{
  Observable<DetailHistoryPpobModel> get getResult => fetcher.stream;
  fetchDetailHistoryPPOBList(var kdTrx) async {
    DetailHistoryPpobModel detailHistoryPPOB =  await repository.fetchDetailHistoryPPOB(kdTrx);
    fetcher.sink.add(detailHistoryPPOB);
  }
}



class DetailHistoryPembelianSuplemenBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<DetailHistoryPembelianSuplemenModel> _serviceController = new PublishSubject<DetailHistoryPembelianSuplemenModel>();
  Observable<DetailHistoryPembelianSuplemenModel> get getResult => _serviceController.stream;
  fetchDetailHistoryPemblianSuplemenList(var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      DetailHistoryPembelianSuplemenModel detailHistoryPembelianSuplemenModel =  await repository.fetchDetailHistoryPembelianSuplemen(id);
      _serviceController.sink.add(detailHistoryPembelianSuplemenModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;

  }
}

//class DetailHistoryPembelianSuplemenBloc extends BaseBloc<DetailHistoryPembelianSuplemenModel>{
//  Observable<DetailHistoryPembelianSuplemenModel> get getResult => fetcher.stream;
//  fetchDetailHistoryPemblianSuplemenList(var id) async {
//    DetailHistoryPembelianSuplemenModel detailHistoryPembelianSuplemen =  await repository.fetchDetailHistoryPembelianSuplemen(id);
//    fetcher.sink.add(detailHistoryPembelianSuplemen);
//  }
//}



class ResiBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<ResiModel> _serviceController = new PublishSubject<ResiModel>();
  Observable<ResiModel> get getResult => _serviceController.stream;
  fetchResi(var resi ,var kurir) async {
    if(_isDisposed) {
      print('false');
    }else{
      ResiModel resiModel =  await repository.fetchResi(resi, kurir);
      _serviceController.sink.add(resiModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;

  }
}
//
//class ResiBloc extends BaseBloc<ResiModel>{
//  Observable<ResiModel> get getResult => fetcher.stream;
//  fetchResi(var resi ,var kurir) async {
//    ResiModel resiList =  await repository.fetchResi(resi, kurir);
//    fetcher.sink.add(resiList);
//  }
//}


final historyPembelianTanahBloc     = HistoryPembelianTanahBloc();
final historyPembelianSuplemenBloc  = HistoryPembelianSuplemenBloc();
final historyPPPOBBloc              = HistoryPPPOBBloc();
final detailHistoryPPPOBBloc        = DetailHistoryPPPOBBloc();
final detailHistoryPembelianSuplemenBloc        = DetailHistoryPembelianSuplemenBloc();
final resiBloc        = ResiBloc();
