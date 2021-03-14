import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) 
  {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName;
    pickUpTextEditingController.text = placeAddress;


    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: black,
                  blurRadius: 7.0,
                  spreadRadius: 0.6,
                  offset: Offset(0.7, 0.7),
                ),
              ]
            ),

            child: Padding(
              padding: EdgeInsets.only(left: 23.0,top: 20.0,right: 25.0,bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 5.0,
                           ),
                  Stack(
                   children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          ),
                      ),
                      Center(
                        child: Text("Set your drop-off", style: TextStyle(color: black,fontSize: 18.0, fontFamily: "Brand-Bold"),),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0,width: 16.0),

                      SizedBox(height: 18.0,),
                      
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Pick-up location",
                              fillColor: Colors.grey[500],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 11.0,top: 8.0, bottom: 8.0),
                            ),
                          ),
                          ),
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0,width: 16.0),

                      SizedBox(height: 18.0,),
                      
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: dropOffTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Where to?",
                              fillColor: Colors.grey[500],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 11.0,top: 8.0, bottom: 8.0),
                            ),
                          ),
                          ),
                      ),
                      ),
                    ],
                  )
                ],
              ),
              ),
          )
        ],
      ),
      
    );
  }
}