import 'package:flutter/material.dart';
import 'package:thaibah/UI/Widgets/radioItem.dart';


class NominalCepat extends StatefulWidget {
  // final List<RadioModel> sampleData;
  final Function(String str) callback;
  NominalCepat({this.callback});
  @override
  _NominalCepatState createState() => _NominalCepatState();
}

class _NominalCepatState extends State<NominalCepat> {
  List<RadioModel> sampleData = new List<RadioModel>();
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(false, '100,000.00', 'Rp 100,000.00'));
    sampleData.add(new RadioModel(false, '200,000.00', 'Rp 200,000.00'));
    sampleData.add(new RadioModel(false, '300,000.00', 'Rp 300,000.00'));
    sampleData.add(new RadioModel(false, '400,000.00', 'Rp 400,000.00'));
    sampleData.add(new RadioModel(false, '500,000.00', 'Rp 500,000.00'));
    sampleData.add(new RadioModel(false, '1,000,000.00', 'Rp 1,000,000.00'));
  }
  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      padding: EdgeInsets.only(top:10, bottom: 10, right: 2),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: _crossAxisSpacing,
        mainAxisSpacing: _mainAxisSpacing,
        childAspectRatio: _aspectRatio,
      ),
      itemCount:sampleData.length,
      itemBuilder: (BuildContext context, int index){
        return new InkWell(
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
              FocusScope.of(context).requestFocus(FocusNode());
            });
            widget.callback(sampleData[index].buttonText);
            // allReplace(sampleData[index].buttonText);
          },
          child: RadioItem(sampleData[index]),
        );
      },
    );
  }
}

