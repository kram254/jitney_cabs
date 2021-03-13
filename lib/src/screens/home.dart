import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/widgets/Divider.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

Completer<GoogleMapController> _controllerGoogleMap = Completer();
GoogleMapController newGoogleMapController;
GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

Position currentPosition;
var geolocator = Geolocator();
double bottomPaddingOfMap = 0;

void locatePosition() async
{
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  currentPosition = position;

  LatLng latLngPosition = LatLng(position.latitude, position.longitude);
  CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
  newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
}

 static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    key: scaffoldKey;
    return Scaffold(
      appBar: AppBar(
        title: Text('Jitney'),
        backgroundColor: Colors.orange,
      ),
      drawer: Container(
        color: white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //DrawerHeader
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: white,
                    ),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png", height: 65.0, width: 65.0),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("User name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                          Text("Visit Profile"),
                        ],
                      ),
                    ],
                  ),  
                 ), 
              ),
              DividerWidget(),
              SizedBox(height: 12.0),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 16.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 16.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 16.0),),
              ),
            ],
          ) ,
          ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                     bottomPaddingOfMap = 265.0;         
                            });

              locatePosition();
            }
           ),

           

           //HamburgerButton for the drawer
           Positioned(
             top: 45.0,
             left: 22.0,
             child: GestureDetector(
               onTap: (){
                  scaffoldKey.currentState.openDrawer();
               },
               child: Container(
                 decoration: BoxDecoration(
                   color: white,
                   borderRadius: BorderRadius.circular(22.0),
                   boxShadow: [
                     BoxShadow(
                       color: black,
                       blurRadius: 6.0,
                       spreadRadius: 0.6,
                       offset: Offset(
                         0.7, 0.7
                       ),
                     ),
                   ]
                 ),
                 child: CircleAvatar(
                   backgroundColor: white,
                   child: Icon(Icons.menu, color: black,),
                   radius: 20.0,
                 ),
               ),
             ),
           ),


          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18) ),
                  boxShadow: [
                    BoxShadow(
                      color: orange,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.0,),
                      Text("Hello there", style: TextStyle(fontSize: 12.0),),
                      Text("Where to", style: TextStyle(fontSize: 20.0,fontFamily: "Brand-Bold"),),
                      SizedBox(height: 6.0,),
                      Container(
                        decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                            BoxShadow(
                              color: orange,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                             ),
                            ],
                           ),

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                            Icon(Icons.search, color: Colors.blue,),
                            SizedBox(width: 10.0,),
                            Text("Search drop-off location"),
                             ],
                             ),
                        ),   

                           ),
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(Icons.home, color: grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text("Add home"),
                              SizedBox(height: 5.0),
                              Text("Living home address",style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                            ],

                          )

                        ],
                      ),
                      SizedBox(height: 10.0,),

                      DividerWidget(),

                      SizedBox(height: 10.0,),

                      Row(
                        children: [
                          Icon(Icons.work, color: grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text("Add work"),
                              SizedBox(height: 5.0),
                              Text("Your office address",style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                            ],

                          )

                        ],
                      )

                    ],
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}