import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/historyPenarikanModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class WithdrawBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchWithdraw(var amount,var id_bank) async =>  await repository.fetchWithdraw(amount, id_bank);
}

class HistoryPenarikanBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<HistoryPenarikanModel> _serviceController = new PublishSubject<HistoryPenarikanModel>();
  Observable<HistoryPenarikanModel> get getResult => _serviceController.stream;
  fetchHistoryPenarikan(var page,var limit, var from, var to) async {
    if(_isDisposed) {
      print('false');
    }else{
      HistoryPenarikanModel historyPenarikanModel =  await repository.fetchHistoryPenarikan(page, limit, from, to);
      _serviceController.sink.add(historyPenarikanModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;

  }
}


final withdrawBloc = WithdrawBloc();
final historyPenarikanBloc = HistoryPenarikanBloc();
