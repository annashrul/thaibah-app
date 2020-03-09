import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thaibah/resources/profileProvider.dart';

class ProfileBloc extends BaseBloc<ProfileModel>{

  bool _isDisposed = false;
  final PublishSubject<ProfileModel> _serviceController = new PublishSubject<ProfileModel>();
  Observable<ProfileModel> get getResult => _serviceController.stream;
  fetchProfileList() async {
    if(_isDisposed) {
      print('false');
    }else{
      ProfileModel profileModel = await repository.fetchAllProfile();
      _serviceController.stream.listen((data){
        print("DataReceived: " + data.status);
      },onDone: (){
        print('task done');
      }, onError: (error){
        print(error);
      });
      _serviceController.sink.add(profileModel);
    }
  }



  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }


//  final ProfileProvider _repository = ProfileProvider();
//  final BehaviorSubject<ProfileModel> _subject =
//  BehaviorSubject<ProfileModel>();
//  fetchProfileList() async {
//    ProfileModel response = await _repository.fetchProfile();
//    _subject.sink.add(response);
//  }
//  dispose() {
//    _subject.close();
//  }
//  BehaviorSubject<ProfileModel> get subject => _subject;
}

final profileBloc = ProfileBloc();