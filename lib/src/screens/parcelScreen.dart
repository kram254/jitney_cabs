import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/helpers/theme.dart';
import 'package:jitney_cabs/src/screens/categories.dart';

class ParcelScreen extends StatefulWidget {
  static const String idScreen = "parcel";

  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {

  _navigateToCategories(BuildContext context) {
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => PackageCategories()));
  }

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
                child: Text('J!tney Parcels',
                   style: TextStyle(color: black, fontSize: 26.0, fontFamily: 'Canterburry')
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
                        child: Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Icon(Feather.package),
                        ),
                      ),
                      Text(
                        "Non-Contact Deliveries",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: kBlackColor,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "When placing an order, select the option \"Contactless delivery\" and the courier will leave your order at the door.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            color: Theme.of(context).buttonColor,
                            child: Text("Order Now"),
                            onPressed: () {
                              _navigateToCategories(context);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            child: Text(
                              "Dismiss",
                              style: TextStyle(
                                color: kTextColor,
                              ),
                            ),
                            onPressed: () {
                              _navigateToCategories(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ) 

            ],
          ),
          ),


      ),
      
    );
  }
}