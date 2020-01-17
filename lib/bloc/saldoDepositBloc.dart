import 'dart:async';

import 'package:thaibah/Model/saldoUIModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';


class SaldoDeposit extends BaseBloc<SaldoResponse> {

  Observable<SaldoResponse> get getResult => fetcher.stream;

  Future<SaldoResponse> fetchSaldo(String saldo, String pin) async =>  await repository.fetchSaldo(saldo, pin);

}

final saldoDepositBloc = SaldoDeposit();
