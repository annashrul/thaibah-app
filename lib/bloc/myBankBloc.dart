import 'package:thaibah/Model/myBankModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class MyBankBloc extends BaseBloc<MyBankModel>{
  Observable<MyBankModel> get allBank => fetcher.stream;
  fetchMyBankList() async {
    MyBankModel myBank =  await repository.fetchMyBank();
    fetcher.sink.add(myBank);
  }


}
class CreateMyBankBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchCreateMyBank(var bankname,var bankcode,var acc_no, var acc_name) async =>  await repository.fetchCreateMyBank(bankname, bankcode, acc_no, acc_name);
}

class DeleteMyBankBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchDeleteMyBank(var id) async =>  await repository.fetchdeleteMyBank(id);
}

final myBankBloc  = MyBankBloc();
final createMyBankBloc = CreateMyBankBloc();
final deleteMyBankBloc = DeleteMyBankBloc();
