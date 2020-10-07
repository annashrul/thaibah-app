import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/config/user_repo.dart';

class UploadImage extends StatefulWidget {
  final Function(String bukti) callback;
  UploadImage({this.callback});
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File _image;
  String dropdownValue = 'pilih';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height:10.0),
        Center(
          child: Container(
            padding: EdgeInsets.only(top:10.0),
            width: 50,
            height: 10.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius:  BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        UserRepository().textQ("Ambil gambar dari ?",12,Colors.black,FontWeight.bold,TextAlign.left),
        SizedBox(height: 10.0),
        Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
            ),
            child: DropdownButton<String>(
              isDense: true,
              isExpanded: true,
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 20,
              underline: SizedBox(),
              onChanged: (newValue) async {
                setState(() {
                  dropdownValue  = newValue;
                });
                if(newValue=='galeri'){
                  final imgGallery = await UserRepository().getImageFile(ImageSource.gallery);
                  setState(() {
                    _image = imgGallery;
                  });
                }
                if(newValue=='kamera'){
                  final imgGallery = await UserRepository().getImageFile(ImageSource.camera);
                  setState(() {
                    _image = imgGallery;
                  });
                }
              },
              items: <String>['pilih','kamera', 'galeri'].map<DropdownMenuItem<String>>((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      UserRepository().textQ(value,12,Colors.grey,FontWeight.bold,TextAlign.left)
                    ],
                  ),
                );
              }).toList(),

            )
        ),
        Divider(),
        Container(
          padding:EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.circular(100.0),
          ),
          child: _image == null ?Image.network("http://lequytong.com/Content/Images/no-image-02.png"): new Image.file(_image,width: 1300,height: MediaQuery.of(context).size.height/2,filterQuality: FilterQuality.high,),
        ),
        SizedBox(height: 10.0),
        UserRepository().buttonQ(context, (){
          if(_image!=null){
            String fileName;
            String base64Image;
            fileName = _image.path.split("/").last;
            var type = fileName.split('.');
            base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(_image.readAsBytesSync());
            widget.callback(base64Image);
          }
        },'Simpan')
      ],
    );


  }
}
