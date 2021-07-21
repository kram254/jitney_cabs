import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class ParcelScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";

  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Scaffold(
          backgroundColor: orange,
          body: Column(
            children: [
              Image(
                image: AssetImage("images/package-delivery.png"),
                height: MediaQuery.of(context).size.height*0.5,
                width: 300.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.only(left:12.0, right:12.0),
                child: Text("Hello, welcome to Jitney Packages",
                style: TextStyle(color: black, fontSize: 26, fontWeight: FontWeight.w700, fontFamily: "Brand bold"),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.only(left:12.0, right:12.0),
                child: Text("Send and receive all your packages with Jitney packages, we're here for you",
                style: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.w400, fontFamily: "Brand bold"),
                ),
              ),
          
              SizedBox(height: 20.0,),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: ()
                {
          
                },
                color: black,
                elevation: 0.5,
                child: Text("Send Package",
                style: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.w400, fontFamily: "Brand bold"),
                ),
                ),
              
              SizedBox(height: 20.0,),
          
                // ignore: deprecated_member_use
              RaisedButton(
                onPressed: ()
                {
          
                },
                color: white,
                elevation: 0.5,
                child: Text("Send Package",
                style: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.w400, fontFamily: "Brand bold"),
                ),
                ),
            ],
          
          ),
        ),
      ),
    );
  }
}