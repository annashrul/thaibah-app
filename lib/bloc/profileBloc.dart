import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thaibah/resources/profileProvider.dart';

class ProfileBloc extends BaseBloc<ProfileModel>{
//  Observable<ProfileModel> get getResult => fetcher.stream;
//  fetchProfileList() async {
//    ProfileModel profile =  await repository.fetchAllProfile();
//    fetcher.sink.add(profile);
//  }


  final ProfileProvider _repository = ProfileProvider();
  final BehaviorSubject<ProfileModel> _subject =
  BehaviorSubject<ProfileModel>();
  fetchProfileList() async {
    ProfileModel response = await _repository.fetchProfile();
    _subject.sink.add(response);
  }
  dispose() {
    _subject.close();
  }
  BehaviorSubject<ProfileModel> get subject => _subject;


}

final profileBloc = ProfileBloc();