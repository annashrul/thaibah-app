import 'package:thaibah/Model/virtualAccount/getAvailableVirtualBankModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class AvailableBankBloc extends BaseBloc<GetAvailableVirtualModel>{
  Observable<GetAvailableVirtualModel> get getResult => fetcher.stream;
  fetchAvailableBank() async {
    GetAvailableVirtualModel availableBank =  await repository.fetchAvailableBank();
    fetcher.sink.add(availableBank);
  }

}
class CreateAvailableVirtualBankBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchCreateAvailableVirtualBank(var amount,var name,var bankcode) async =>  await repository.fetchCreateAvailableVirtualBank(amount, name, bankcode);
}

final availableBankBloc = AvailableBankBloc();
final createAvailableVirtualBankBloc = CreateAvailableVirtualBankBloc();