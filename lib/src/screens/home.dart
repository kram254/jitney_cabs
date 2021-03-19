import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/src/assistants/assistantMethods.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:jitney_cabs/src/screens/searchScreen.dart';
import 'package:jitney_cabs/src/widgets/Divider.dart';
import 'package:jitney_cabs/src/widgets/progressDialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

Completer<GoogleMapController> _controllerGoogleMap = Completer();
GoogleMapController newGoogleMapController;
GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

List<LatLng> pLineCoordinates = [];
Set<Polyline> polylineSet = {};

Set<Marker> markerSet = {};
Set<Circle> circleSet = {};

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

  String address = await AssistantMethods.searchCoordinateAddress(position, context);
  print("This is your address:: "+ address);
}

 static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: scaffoldKey,
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
            polylines: polylineSet,
            markers: markerSet,
            circles:  circleSet,
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
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: () async
                        {
                          var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

                          if(res == "obtainDirection")
                          {
                            await getPlaceDirection();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                              BoxShadow(
                                color: black,
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
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(Icons.home, color: grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickUpLocation != null
                                  ? Provider.of<AppData>(context).pickUpLocation
                                  :"Add home"
                              ),
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

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
      context: context, 
      builder: (BuildContext content) => ProgressDialog(message: "Please wait...",)
    );
    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    Navigator.pop(context);

    print("This is encoded points :");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);
     
    pLineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty)
    {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng)
      {
         pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
     Polyline polyline = Polyline(
      color: orange,
      polylineId: PolylineId("PolylineID"),
      jointType: JointType.round,
      points: pLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
      );

      polylineSet.add(polyline);
        });

      LatLngBounds latLngBounds;
      if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
      }
      else if(pickUpLatLng.longitude> dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), 
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
      }
      else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
      {
        latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), 
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
      } 
      else 
      {
        latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      }

      newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My location"),
        position:  pickUpLatLng,
        markerId: MarkerId("pickUpId"),
      );

      Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Drop-off location"),
        position:  dropOffLatLng,
        markerId: MarkerId("dropOffId"),
      );

      setState(() {
              markerSet.add(pickUpLocMarker);
              markerSet.add(dropOffLocMarker);
            });

      Circle pickUpLocCircle = Circle(
        fillColor: Colors.blue,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("pickUpId")
      );

      Circle dropOffLocCircle = Circle(
        fillColor: Colors.red,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.redAccent,
        circleId: CircleId("dropOffId"),
      ); 

      setState(() {
              circleSet.add(pickUpLocCircle);
              circleSet.add(dropOffLocCircle);
            }); 
  }

}