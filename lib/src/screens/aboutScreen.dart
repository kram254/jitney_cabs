import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/screens/home.dart';

class AboutScreen extends StatefulWidget{
 static const String idScreen = "about";
  @override
  _AboutScreenState createState() => _AboutScreenState();
}
class _AboutScreenState extends State<AboutScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ListView(
        children: [
          //car icon
          Container(
            height: 220.0,
            child: Center(
              child: Image.asset("images/jitneylux"),
            ),
          ),
          // appname && description
          Padding(
          padding: EdgeInsets.only(top:30, left: 24.0, right: 24.0),
          child: Column(
             children:[
             Text("J!tney",
             style: TextStyle(fontSize: 90.0, fontFamily: "Brand bold"
             ),
             ),
             SizedBox(height: 30,),
             Text("Just developed by Mark",
             style: TextStyle(fontFamily: "Brand bold", color: Colors.white),
             textAlign: TextAlign.center,
             ),


             ],
          ),
          ),
          //Go back button
          SizedBox(height: 40,),

          // ignore: deprecated_member_use
          FlatButton(
          onPressed: ()
          {
           Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
          }, 
          child: const Text(
          "Go back", style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          ),
        ],
      ),

    );
  }
}