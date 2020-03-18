import 'dart:ui';
import 'package:flutter/material.dart';

class RichAlertDialogQ extends StatefulWidget {
  /// The title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// Usually has a bigger fontSize than the [alertSubtitle].
  final Text alertTitle;

  /// The subtitle of the dialog is displayed in a medium-sized font beneath
  /// the title of the dialog.
  ///
  /// Usually has a smaller fontSize than the [alertTitle]
  final Text alertSubtitle;

  /// The type of dialog, whether warning, success or error.
  final int alertType;

  /// The (optional) actions to be performed in the dialog is displayed
  /// the subtitle of the dialog. If no values are provided, a default
  /// [Button] widget is rendered.
  ///
  /// Typically a [List<Widget>] widget.
  final List<Widget> actions;

  /// Specifies how blur the screen overlay effect should be.
  /// Higher values mean more blurred overlays.
  final double blurValue;

  // Specifies the opacity of the screen overlay
  final double backgroundOpacity;

  /// (Optional) User defined icon for the dialog. Advisable to use the
  /// default icon matching the dialog type.
  final Icon dialogIcon;

  RichAlertDialogQ({
    Key key,
    @required this.alertTitle,
    @required this.alertSubtitle,
    @required this.alertType,
    this.actions,
    this.blurValue,
    this.backgroundOpacity,
    this.dialogIcon,
  }) : super(key: key);

  createState() => _RichAlertDialogQState();
}

class _RichAlertDialogQState extends State<RichAlertDialogQ> {
  Map<int, AssetImage> _typeAsset = {
    RichAlertType.ERROR: AssetImage("assets/images/icon_error.png"),
    RichAlertType.SUCCESS: AssetImage("assets/images/icon_success.png"),
    RichAlertType.WARNING: AssetImage("assets/images/icon_warning.png"),
  };

  Map<int, Color> _typeColor = {
    RichAlertType.ERROR: Colors.red,
    RichAlertType.SUCCESS: Colors.green,
    RichAlertType.WARNING: Colors.blue,
  };

  double deviceWidth;
  double deviceHeight;
  double dialogHeight;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;

    deviceWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;
    deviceHeight = orientation == Orientation.portrait
        ? screenSize.height
        : screenSize.width;
    dialogHeight = deviceHeight * (2 / 5);

    return MediaQuery(
      data: MediaQueryData(),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurValue != null ? widget.blurValue : 3.0,
          sigmaY: widget.blurValue != null ? widget.blurValue : 3.0,
        ),
        child: Container(
          height: deviceHeight,
          color: Colors.white.withOpacity(widget.backgroundOpacity != null
              ? widget.backgroundOpacity
              : 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                        height: dialogHeight,
                        width: deviceWidth * 0.9,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: dialogHeight / 4),
                              widget.alertTitle,
                              SizedBox(height: dialogHeight / 10),
                              widget.alertSubtitle,
                              SizedBox(height: dialogHeight / 10),
                              widget.actions != null &&
                                  widget.actions.isNotEmpty
                                  ? _buildActions()
                                  : _defaultAction(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: dialogHeight - 50,
                      child: widget.dialogIcon != null
                          ? widget.dialogIcon
                          : _defaultIcon(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildActions() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions,
      ),
    );
  }

  Image _defaultIcon() {
    return Image(
      image: _typeAsset[widget.alertType],
      width: deviceHeight / 7,
      height: deviceHeight / 7,
    );
  }

  Container _defaultAction(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        elevation: 2.0,
        color: _typeColor[widget.alertType],
        child: Text(
          "GOT IT",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

Text richTitle(String title) {
  return Text(
    title,
    style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold),
  );
}

Text richSubtitle(String subtitle) {
  return Text(
    subtitle,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.grey,fontFamily: 'Rubik',fontWeight: FontWeight.bold
    ),
  );
}

class RichAlertType {
  /// Indicates an error dialog by providing an error icon.
  static const int ERROR = 0;

  /// Indicates a success dialog by providing a success icon.
  static const int SUCCESS = 1;

  /// Indicates a warning dialog by providing a warning icon.
  static const int WARNING = 2;
}
