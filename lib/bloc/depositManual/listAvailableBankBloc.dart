import 'package:thaibah/Model/depositManual/detailDepositModel.dart';
import 'package:thaibah/Model/depositManual/historyDepositModel.dart';
import 'package:thaibah/Model/depositManual/listAvailableBank.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class ListAvailableBankBloc extends BaseBloc<ListAvailableBankModel>{
  Observable<ListAvailableBankModel> get getResult => fetcher.stream;
  fetchListAvailableBank() async {
    ListAvailableBankModel listAvailableBank =  await repository.fetchAllListAvailableBank();
    fetcher.sink.add(listAvailableBank);
  }
}
class DetailDepositBloc extends BaseBloc<DetailDepositModel> {
  Observable<DetailDepositModel> get getResult => fetcher.stream;
  Future<DetailDepositModel> fetchDetailDeposit(var id_bank,var amount) async =>  await repository.fetchDetailDeposit(id_bank, amount);
}

class UploadBuktiTransferBloc extends BaseBloc<General>{
  Observable<General> get getResult => fetcher.stream;
  Future<General> fetchUploadBuktiTransfer(var id_deposit,var bukti) async =>  await repository.fetchUploadBuktiTransfer(id_deposit, bukti);
}

class HistoryDepositBloc extends BaseBloc<HistoryDepositModel>{
  Observable<HistoryDepositModel> get getResult => fetcher.stream;
  fetchHistoryDeposit(var page,var limit,var from,var to) async {
    HistoryDepositModel historyDeposit =  await repository.fetchHistoryDeposit(page, limit,from,to);
    fetcher.sink.add(historyDeposit);
  }
}

final listAvailableBankBloc   = ListAvailableBankBloc();
final detailDepositBloc       = DetailDepositBloc();
final uploadBuktiTransferBloc = UploadBuktiTransferBloc();
final historyDepositBloc      = HistoryDepositBloc();
