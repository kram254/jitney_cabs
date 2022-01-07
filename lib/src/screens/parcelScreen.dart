import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/screens/sendPackage.dart';

class ParcelScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";

  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0)),
                color: orange,
                boxShadow: [
                  BoxShadow(
                    //blurRadius: 6.0,
                    //spreadRadius: 0.6,
                    offset: Offset(0.7, 0.7),
                  ),
                ]),
            child: Column(
              children: [
                Image(
                  image: AssetImage("images/package-delivery.png"),
                  height: MediaQuery.of(context).size.height * 0.38,
                  width: 300.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Text(
                    "Hello, welcome to Jitney Packages",
                    style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Brand bold"),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Text(
                    "Send and receive all your packages with Jitney packages, we're here for you",
                    style: TextStyle(
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Brand bold"),
                  ),
                ),

                SizedBox(
                  height: 15.0,
                ),

                //      GestureDetector(
                //             onTap: ()
                //             {
                //                Navigator.push(context, MaterialPageRoute(builder: (context) => SendPackage()));
                //             },
                //             child:  Card(
                //             color: Colors.white,
                //             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                //             child: ListTile(
                //                      leading: Icon(
                //                           icon,
                //                      color:  Colors.black87,

                //                        ),

                //                    title: Text(
                //                             text,
                //                    style: TextStyle(
                //                    color: Colors.black87,
                //                    fontSize: 16.0,
                //                    fontFamily: "Brand bold",

                //             ),
                //           ),
                //         ),
                //   ),
                // ),

                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SendPackage()));
                  },
                  color: black,
                  elevation: 2.0,
                  child: Text(
                    "  Send Package   ",
                    style: TextStyle(
                        color: white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Brand bold"),
                  ),
                ),

                SizedBox(
                  height: 15.0,
                ),

                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivePackage()));
                  },
                  color: white,
                  elevation: 2.0,
                  child: Text(
                    "Receive Package",
                    style: TextStyle(
                        color: black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Brand bold"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
