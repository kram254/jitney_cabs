import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/widgets/roundedIconBtn.dart';

class DetailsPage extends StatefulWidget {
  //const DetailsPage({ Key? key }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: RoundedIconBtn(
            iconData: Icons.arrow_back_ios,
            press: () => Navigator.pop(context),
          ),
        ),
      ),

    //  body: ,
      
    );
  }
}