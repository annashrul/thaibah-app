import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class PpobPraBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<PpobPraModel> _serviceController = new PublishSubject<PpobPraModel>();
  Observable<PpobPraModel> get getResult => _serviceController.stream;
  fetchPpobPra(var type,var nohp) async {
    if(_isDisposed) {
      print('false');
    }else{
      PpobPraModel ppobPraModel =  await repository.fetchPpobPra(type,nohp);
      _serviceController.sink.add(ppobPraModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class CheckoutPpobPraBloc extends BaseBloc<General> {
  Observable get getResult => fetcher.stream;
  Future fetchCheckoutPpobPra(var no,var code,var price, var charge, var idpelanggan) async =>  await repository.fetchCheckoutPpobPra(no, code, price, charge,idpelanggan);
}

final ppobPraBloc       = PpobPraBloc();
final checkoutPpobPraBloc       = CheckoutPpobPraBloc();
