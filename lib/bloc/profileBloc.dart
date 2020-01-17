import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BaseBloc<ProfileModel>{
  Observable<ProfileModel> get getResult => fetcher.stream;
  fetchProfileList() async {
    ProfileModel profile =  await repository.fetchAllProfile();
    fetcher.sink.add(profile);
  }

}

final profileBloc = ProfileBloc();