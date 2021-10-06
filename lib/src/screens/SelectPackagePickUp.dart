import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/src/assistants/assistantMethods.dart';
import 'package:jitney_cabs/src/assistants/geoFireAssistant.dart';
import 'package:jitney_cabs/src/helpers/configMaps.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/models/directionDetails.dart';
import 'package:jitney_cabs/src/models/nearbyAvailableDrivers.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:jitney_cabs/src/screens/packageSearchScreen.dart';
import 'package:jitney_cabs/src/services/places_service.dart';
import 'package:jitney_cabs/src/widgets/Divider.dart';
import 'package:jitney_cabs/src/widgets/address_search.dart';
import 'package:jitney_cabs/src/widgets/progressDialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SelectPackagePickUp extends StatefulWidget {
 /// const SelectPackagePickUp({ Key? key }) : super(key: key);

  @override
  _SelectPackagePickUpState createState() => _SelectPackagePickUpState();
}

class _SelectPackagePickUpState extends State<SelectPackagePickUp> {

final _controller = TextEditingController();
  // String _streetNumber = '';
  // String _street = '';
  // String _city = '';
  // String _zipCode = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
 Set<Polyline> polylineSet = {};
 Set<Marker> markerSet = {};
 Set<Circle> circleSet = {};
 double bottomPaddingOfMap = 0;
 bool drawerOpen = true;
 Position currentPosition;
 bool nearbyAvailableDriverKeysLoaded = false;
 String uName = " ";
 BitmapDescriptor nearbyIcon;
 
 Completer<GoogleMapController> _controllerGoogleMap = Completer();
 GoogleMapController newGoogleMapController;
 GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
 double searchContainerHeight = 300.0;
 double rideDetailsContainerHeight = 0;
 DirectionDetails tripDirectionDetails;
 List<LatLng> pLineCoordinates = [];

 static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  resetApp()
{
  setState(() {
      drawerOpen = true;
      // searchContainerHeight = 300.0;
      // rideDetailsContainerHeight = 0;
      // requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230.0;

      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      // pLineCoordinates.clear();

      // statusRide = " ";
      // driverName = " ";
      // driverPhone = " ";
      // carDetailsDriver = " ";
      // rideStatus = "Driver is coming";
      // driverDetailsContainerheight = 0.0;
    });

    locatePosition();
}
void locatePosition() async
{
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  currentPosition = position;

  LatLng latLngPosition = LatLng(position.latitude, position.longitude);
  CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
  newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  String address = await AssistantMethods.searchCoordinateAddress(position, context);
  print("This is your address:: "+ address);
  initGeoFireListener();

  uName = userCurrentInfo.name;

  AssistantMethods.retrieveHistoryInfo(context);
}

void displayRideDetailsContainer() async
{
  await getPlaceDirection();
  
  setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 340.0;
      bottomPaddingOfMap = 360.0;
      drawerOpen = false;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              }
              
             ),

             //HamburgerButton for the drawer
            Positioned(
               top: 38.0,
               left: 22.0,
               child: GestureDetector(
                 onTap: ()
                 {
                    if(drawerOpen)
                    {
                      scaffoldKey.currentState.openDrawer();
                    }
                    else
                    {
                      resetApp();
                    }
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
                     backgroundColor: orange,
                     child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: black,),
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
                 height: 245.0,
                 decoration: BoxDecoration(
                   color: white,
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0) ),
                      boxShadow: [
                        BoxShadow(
                          //color: orange,
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
                          Text("Package pick-up location.", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20.0,fontFamily: "Brand-Bold"),),
                          SizedBox(height: 20.0,),
                          GestureDetector(
                            onTap: () async
                            {
                              var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => PackageSearchScreen()));
    
                              if(res == "obtainDirection")
                              {
                                displayRideDetailsContainer();
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                color: grey,
                                borderRadius: BorderRadius.circular(35.0),
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
                                  padding: const EdgeInsets.only(left:12.0, right:12.0),
                                  child: Row(
                                    children: [
                                    Icon(Icons.search, color: orange,),
                                    SizedBox(width: 10.0,),
                                    Text("Search pick-up location"),
                                     ],
                                     ),
                                   ), 
                            ),
                          ),

                          SizedBox(height: 15.0),
                          Row(
                            children: [
                              Icon(Icons.home, color: orange,),
                              SizedBox(width: 12.0,),
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                   Text(
                                       Provider.of<AppData>(context).pickUpLocation != null 
                                       ? Provider.of<AppData>(context).pickUpLocation.placeName 
                                       : "Add home",
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
                              Icon(Icons.work, color: orange,),
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
    
                        ]
                      ),
                 ),
               ),

             ),

             

            //  Positioned(
            //    top:50.0,
               
            //    child: Expanded(
            //      child: Row(
            //        children: [
            //          Expanded(
            //            child: SizedBox(
            //              height: 40.0,
                         
            //              child: TextField(
            //              controller: _controller,
            //              readOnly: true,
            //              onTap: () async {
            //                // generate a new token here
            //                final sessionToken = Uuid().v4();
            //                final Suggestion result = await showSearch(
            //                context: context,
            //                delegate: AddressSearch(sessionToken),
            //                 );
            //                  // This will change the text displayed in the TextField
            //                 if (result != null) {
            //                   final placeDetails = await PlaceApiProvider(sessionToken)
            //                   .getPlaceDetailFromId(result.placeId);
            //                   setState(() {
            //                   _controller.text = result.description;
            //                   _streetNumber = placeDetails.streetNumber;
            //                   _street = placeDetails.street;
            //                   _city = placeDetails.city;
            //                   _zipCode = placeDetails.zipCode;
            //                });
            //               }
            //                 // with some styling
            //              decoration: InputDecoration(
            //                 icon: Container(
            //                 margin: EdgeInsets.only(left: 20),
            //                 width: 10,
            //                 height: 10,
            //                 child: Icon(
            //                            Icons.search_outlined,
            //                            color: orange,
            //                          ),
            //                      ),
            //              hintText: "Search drop-off location",
            //              border: InputBorder.none,
            //              contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
            //                    );
            //              }
            //                  ),
            //            ),
            //          ),

            //            SizedBox(height: 20.0),
            //            Text('Street Number: $_streetNumber'),
            //            Text('Street: $_street'),
            //            Text('City: $_city'),
            //            Text('ZIP Code: $_zipCode'),
            //        ],
            //      ),
            //    ),
            //  ),

            // ignore: deprecated_member_use
          //   RaisedButton(
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //   child: Text(
          //     "Select here",
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(4.0),
          //   ),
          //   onPressed: () {
          //     //location picker
              
          //   },
          // ),
        ],
      ),
      
    );
  }

  void initGeoFireListener()
  {
    ///
     Geofire.initialize("availableDrivers");  
     Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 5).listen((map) {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];

          //latitude will be retrieved from map['latitude']
          //longitude will be retrieved from map['longitude']

          switch (callBack) {
            case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers = NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableDriversList.add(nearbyAvailableDrivers);
            if(nearbyAvailableDriverKeysLoaded == true)
            {
              updateAvailableDriversOnMap();
            }

              break;

            case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
              break;

            case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers = NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
              break;

            case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
              break;
          }
        }

        setState(() {});
        
     });
    ///
  }

 void updateAvailableDriversOnMap()
  {
    setState(() {
          markerSet.clear();
        });

     Set<Marker> tMarker = Set<Marker>();
     for(NearbyAvailableDrivers driver in GeoFireAssistant.nearByAvailableDriversList)
     {
       LatLng driversAvailablePosition = LatLng(driver.latitude, driver.longitude);

       Marker marker = Marker(
         markerId: MarkerId('driver${driver.key}'),
         position: driversAvailablePosition,
         icon: nearbyIcon,
         rotation: AssistantMethods.createRandomNumber(360),
       );
       tMarker.add(marker);
     } 
     setState(() {
            markerSet = tMarker;
          });
  }

  Future <void> getPlaceDirection() async
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

    setState(() {
          tripDirectionDetails = details;
        });
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