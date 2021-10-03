import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key key, 
    @required this.iconData, 
    @required this.press,
  }) : super(key: key);

   final IconData iconData;
   final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0, 
      width: 40.0,
      // ignore: deprecated_member_use
      child: FlatButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        color: orange,
        onPressed: press,
        child: Icon(iconData),

      ),
      );
  }
}