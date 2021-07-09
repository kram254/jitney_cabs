import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class ParcelScreen extends StatefulWidget {
  static const String idScreen = "parcel";

  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
           image: const DecorationImage(
             image: AssetImage('images/background.png'),
             fit: BoxFit.cover,
             ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('J!tney',
                   style: TextStyle(color: black, fontSize: 26.0, fontFamily: 'Canterburry')
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Parcels',
                   style: TextStyle(color: black, fontSize: 26.0, fontFamily: 'Canterburry')
                ),
              ),
            ],
          ),
          ),


      ),
      
    );
  }
}