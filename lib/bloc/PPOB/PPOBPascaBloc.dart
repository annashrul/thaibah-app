import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class PpobPascaBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<PpobPascaModel> _serviceController = new PublishSubject<PpobPascaModel>();
  Observable<PpobPascaModel> get getResult => _serviceController.stream;
  fetchPpobPasca(var type) async {
    if(_isDisposed) {
      print('false');
    }else{
      PpobPascaModel ppobPascaModel =  await repository.fetchPpobPasca(type);
      _serviceController.sink.add(ppobPascaModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}

class PpobPascaCekTagihan extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchPpobPascaCekTagihan(var code,var no,var idpelanggan) async =>  await repository.fetchPpobPascaCekTagihan(code, no, idpelanggan);
}

class PpobPascaCheckout extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchPpobPascaCheckout(var code,var orderid,var price) async =>  await repository.fetchPpobPascaCheckout(code, orderid, price);
}


final ppobPascaBloc       = PpobPascaBloc();
final ppobPascaCekTagihan = PpobPascaCekTagihan();
final ppobPascaCheckout   = PpobPascaCheckout();
