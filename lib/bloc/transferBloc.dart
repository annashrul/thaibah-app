import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/transferDetailModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class TransferBloc extends BaseBloc<GeneralInsertId> {
  Observable<GeneralInsertId> get getResult => fetcher.stream;
  Future<GeneralInsertId> fetchTransfer(var saldo,var referral_penerima,var pesan) async =>  await repository.fetchTransfer(saldo, referral_penerima, pesan);
}

class TransferDetailBloc extends BaseBloc<TransferDetailModel> {
  Observable<TransferDetailModel> get getResult => fetcher.stream;
  Future<TransferDetailModel> fetchTransferDetail(var nominal,var referral_penerima,var pesan) async =>  await repository.fetchTransferDetail(nominal, referral_penerima,pesan);
}

class TransferBonusBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchTransferBonus(var saldo) async =>  await repository.fetchTransferBonus(saldo);
}

final transferBloc = TransferBloc();
final transferDetailBloc = TransferDetailBloc();
final transferBonusBloc = TransferBonusBloc();
