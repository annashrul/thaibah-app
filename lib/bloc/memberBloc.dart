import 'package:thaibah/Model/member/contactModel.dart';
import 'package:thaibah/Model/memberModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
class MemberBloc extends BaseBloc<MemberModel>{
  Observable<MemberModel> get getResult => fetcher.stream;
  fetchMemberList(var id) async {
    MemberModel member =  await repository.fetchMember(id);
    fetcher.sink.add(member);
  }
}
class ContactBloc extends BaseBloc{
//  Observable<ContactModel> get getResult => fetcher.stream;
//  fetchContactList() async {
//    ContactModel contact =  await repository.fetchContact();
//    fetcher.sink.add(contact);
//  }

  bool _isDisposed = false;
  final PublishSubject<ContactModel> _serviceController = new PublishSubject<ContactModel>();
  Observable<ContactModel> get getResult => _serviceController.stream;
  fetchContactList() async {
    if(_isDisposed) {
      print('false');
    }else{
      ContactModel contact =  await repository.fetchContact();
      _serviceController.sink.add(contact);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;

  }

}

class CreateMemberBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchCreateMember(
    var pin,
    var name,
    var ismobile,
    var no_hp,
    var referral,
//    var ktp
  ) async =>  await repository.fetchCreateMember(
    pin,
    name,
    ismobile,
    no_hp,
    referral,
//    ktp
  );
}
class UpdateMemberBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchUpdateMember(var name,var no_hp, var gender, var picture, var cover, var ktp) async =>  await repository.fetchUpdateMember(name, no_hp, gender,picture, cover,ktp);
}
class UpdatePinMemberBloc extends BaseBloc {
  Observable get getResult => fetcher.stream;
  Future fetchUpdatePinMember(var pin) async =>  await repository.fetchUpdatePinMember(pin);
}


final memberBloc = MemberBloc();
final contactBloc = ContactBloc();
final createMemberBloc = CreateMemberBloc();
final updateMemberBloc = UpdateMemberBloc();
final updatePinMemberBloc = UpdatePinMemberBloc();
