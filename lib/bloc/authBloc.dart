import 'package:thaibah/Model/authModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class AuthEmailBloc extends BaseBloc<AuthModel> {
  Observable<AuthModel> get getResult => fetcher.stream;
  Future<AuthModel> fetchAuthEmail(String email,String password) async =>  await repository.fetchLoginEmail(email, password);
}


class AuthNoHpBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchAuthNoHp(var nohp,var deviceid,var typeotp) async =>  await repository.fetchLoginNohp(nohp, deviceid,typeotp);
}


final authEmailBloc = AuthEmailBloc();
final authNoHpBloc = AuthNoHpBloc();
