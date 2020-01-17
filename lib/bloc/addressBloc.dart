import 'package:thaibah/Model/address/getAddressModel.dart';
import 'package:thaibah/Model/address/getListAddressModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class AddressBloc extends BaseBloc<AddressModel>{
  Observable<AddressModel> get allAddress => fetcher.stream;
  fetchAddressList() async {
    AddressModel address =  await repository.fetchAddress();
    fetcher.sink.add(address);
  }
}

class GetAddressBloc extends BaseBloc<GetAddressModel>{
  Observable<GetAddressModel> get allAddress => fetcher.stream;
  fetchGetAddressList(var id) async {
    GetAddressModel address =  await repository.fetchGetAddress(id);
    fetcher.sink.add(address);
  }
}


class UpdateAddresskBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetcUpdateAddress(var title,var name,var main_address,var kd_prov,var kd_kota, var kd_kec, var no_hp, var id) async =>  await repository.fetchUpdateAddress(title, name, main_address, kd_prov, kd_kota, kd_kec, no_hp, id);
}

class AddAddressBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetcAddAddress(var title,var name,var main_address,var kd_prov,var kd_kota, var kd_kec, var no_hp) async =>  await repository.fetchCreateAddress(title, name, main_address, kd_prov, kd_kota, kd_kec, no_hp);
}


final addressBloc         = AddressBloc();
final updateAddressBloc   = UpdateAddresskBloc();
final addAddressBloc      = AddAddressBloc();
