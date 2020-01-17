import 'package:thaibah/Model/detailNewsPerCategoryModel.dart';
import 'package:thaibah/Model/newsDetailModel.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/bloc/base.dart';
import 'package:rxdart/rxdart.dart';


class NewsBloc extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<NewsModel> _serviceController = new PublishSubject<NewsModel>();
  Observable<NewsModel> get allNews => _serviceController.stream;
  fetchNewsList(var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      NewsModel news =  await repository.fetchAllNews(page,limit);
      _serviceController.sink.add(news);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class NewsDetailBloc extends BaseBloc<NewsDetailModel>{
  bool _isDisposed = false;
  final PublishSubject<NewsDetailModel> _serviceController = new PublishSubject<NewsDetailModel>();
  Observable<NewsDetailModel> get allDetailNews => _serviceController.stream;
  fetchNewsDetail(var id) async {
    if(_isDisposed) {
      print('false');
    }else{
      NewsDetailModel news =  await repository.fetchDetailNews(id);
      _serviceController.sink.add(news);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

class NewsHomeBloc extends BaseBloc<NewsModel>{
  bool _isDisposed = false;
  final PublishSubject<NewsModel> _serviceController = new PublishSubject<NewsModel>();
  Observable<NewsModel> get allHomeNews => _serviceController.stream;
  fetchNewsHomeList(var title) async {
    if(_isDisposed) {
      print('false');
    }else{
      NewsModel news =  await repository.fetchAllHomeNews(title);
      _serviceController.sink.add(news);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }

}


class NewsDetailPerCategory extends BaseBloc{
  bool _isDisposed = false;
  final PublishSubject<DetailNewsPerCategoryModel> _serviceController = new PublishSubject<DetailNewsPerCategoryModel>();
  Observable<DetailNewsPerCategoryModel> get allDetailNewsPerCategory => _serviceController.stream;
  fetchDetailNewsPerCategory(var page,var limit,var title) async {
    if(_isDisposed) {
      print('false');
    }else{
      DetailNewsPerCategoryModel detailNewsPerCategoryModel =  await repository.fetchAllDetailNewsPerCategory(page,limit,title);
      _serviceController.sink.add(detailNewsPerCategoryModel);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}



final newsBloc  = NewsBloc();
final newsDetailBloc  = NewsDetailBloc();
final newsHomeBloc = NewsHomeBloc();
final newsDetailPerCategory = NewsDetailPerCategory();
