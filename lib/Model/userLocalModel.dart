import 'dart:math';

class UserLocalModel {
  int _id;
  String _name;
  String _phone;
  String _token;
  String _referral;
  String _pin;
  String _status;

  // konstruktor versi 1
  UserLocalModel(this._name, this._phone, this._token,this._referral,this._pin,this._status);

  // konstruktor versi 2: konversi dari Map ke Contact
  UserLocalModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._phone = map['phone'];
    this._token = map['token'];
    this._referral = map['referral'];
    this._pin = map['pin'];
    this._status = map['status'];
  }

  //getter dan setter (mengambil dan mengisi data kedalam object)
  // getter
  int get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get token => _token;
  String get referral => _referral;
  String get pin => _pin;
  String get status => _status;

  // setter
  set name(String value) {
    _name = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set token(String value) {
    _token = value;
  }

  set referral(String value) {
    _referral = value;
  }
  set pin(String value) {
    _pin = value;
  }
  set status(String value) {
    _status = value;
  }

  // konversi dari Contact ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['phone'] = phone;
    map['token'] = token;
    map['referral'] = referral;
    map['pin'] = pin;
    map['status'] = status;
    return map;
  }

}