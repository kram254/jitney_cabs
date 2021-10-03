import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class Body extends StatelessWidget {
  //const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          BottomRoundedContainer(
            color: white,
            //child: 
          ),
        ],
      ),
    );
  }
}

class BottomRoundedContainer extends StatelessWidget {
  const BottomRoundedContainer({
    Key key,
    @required this.color,
    //@required this.child,
    
  }) : super(key: key);

  final Color color;
 // final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( top: 20.0),
      padding: EdgeInsets.only( top: 20.0),
      width: double.infinity,
      height: 800.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),

        ),
      ),
      //child: child,
    );
  }
}