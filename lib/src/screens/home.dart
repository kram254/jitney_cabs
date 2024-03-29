import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/main.dart';
import 'package:jitney_cabs/src/assistants/assistantMethods.dart';
import 'package:jitney_cabs/src/assistants/geoFireAssistant.dart';
import 'package:jitney_cabs/src/helpers/configMaps.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/helpers/toastDisplay.dart';
import 'package:jitney_cabs/src/models/directionDetails.dart';
import 'package:jitney_cabs/src/models/nearbyAvailableDrivers.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:jitney_cabs/src/screens/aboutScreen.dart';
import 'package:jitney_cabs/src/screens/historyScreen.dart';
import 'package:jitney_cabs/src/screens/loginScreen.dart';
import 'package:jitney_cabs/src/screens/parcelScreen.dart';
import 'package:jitney_cabs/src/screens/profileTab.dart';
import 'package:jitney_cabs/src/screens/ratingScreen.dart';
import 'package:jitney_cabs/src/screens/searchScreen.dart';
import 'package:jitney_cabs/src/widgets/Divider.dart';
import 'package:jitney_cabs/src/widgets/collectFareDialog.dart';
import 'package:jitney_cabs/src/widgets/noDriverAvailableDialog.dart';
import 'package:jitney_cabs/src/widgets/progressDialog.dart';
//import 'package:jitney_cabs/src/providers/user.dart';
//import 'package:jitney_cabs/src/screens/loginScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin
{

Completer<GoogleMapController> _controllerGoogleMap = Completer();
GoogleMapController newGoogleMapController;
GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

DirectionDetails tripDirectionDetails;

List<LatLng> pLineCoordinates = [];
Set<Polyline> polylineSet = {};
Set<Marker> markerSet = {};
Set<Circle> circleSet = {};
Position currentPosition;
var geolocator = Geolocator();
double bottomPaddingOfMap = 0;
double rideDetailsContainerHeight = 0;
double requestRideContainerHeight = 0;
double searchContainerHeight = 300.0;
double driverDetailsContainerheight = 0;
DatabaseReference rideRequestRef;
bool drawerOpen = true;
bool nearbyAvailableDriverKeysLoaded = false;
BitmapDescriptor nearbyIcon;
List<NearbyAvailableDrivers> availableDrivers;
String state = "normal";
StreamSubscription<Event> rideStreamSubscription;
bool isRequestingPositiondetails = false;
String uName = " ";

@override
  void initState() {
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
  }

 void saveRideRequest()
 {
   rideRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests").push();

   var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;

   var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

   Map pickUpLocMap =
   {
     "latitude": pickUp.latitude.toString(),
     "longitude": pickUp.longitude.toString(),
   };

   Map dropOffLocMap =
   {
     "latitude": dropOff.latitude.toString(),
     "longitude": dropOff.longitude.toString(),
   };

   Map rideInfoMap =
   {
     "driver_id": "waiting",
     "payment_method": "cash",
     "pickUp": pickUpLocMap,
     "dropOff": dropOffLocMap,
     "created_at": DateTime.now().toString(),
     "rider_name": userCurrentInfo.name,
     "rider_phone": userCurrentInfo.phone,
     "pickup_address": pickUp.placeName,
     "dropoff_address": dropOff.placeName,
     "ride_type": carRideType,
   };

   rideRequestRef.set(rideInfoMap);

   rideStreamSubscription = rideRequestRef.onValue.listen((event) async
   {
     if(event.snapshot.value == null){
       return;
     }

     if(event.snapshot.value["car_details"] != null)
     {
       setState(() {
         carDetailsDriver = event.snapshot.value["car_details"].toString();
       });
     }

     if(event.snapshot.value["driver_name"] != null)
     {
       setState(() {
         driverName = event.snapshot.value["driver_name"].toString();
       });
     }

     if(event.snapshot.value["driver_phone"] != null)
     {
       setState(() {
         driverPhone = event.snapshot.value["driver_phone"].toString();
       });
     }

     if(event.snapshot.value["driver_location"] != null)
     {
          double driverLat = double.parse(event.snapshot.value["driver_location"]["latitude"].toString());
          double driverLng = double.parse(event.snapshot.value["driver_location"]["longitude"].toString());
          LatLng driverCurrentLocation = LatLng(driverLat, driverLng);
          if(statusRide == "accepted")
          {
            updateRideTimeToPickUpLoc(driverCurrentLocation);
          }
          else if(statusRide == "onride")
          {
            updateRideTimeToDropOffLoc(driverCurrentLocation);
          }
          else if(statusRide == "arrived")
          {
            setState(() {
              rideStatus = "Driver has arrived";
            });
          }
     }

     if(event.snapshot.value["status"] != null)
     {
       statusRide = event.snapshot.value["status"].toString();
     }

     if(statusRide == "accepted")
     {
       displayDriverDetailsContainer();
       Geofire.stopListener();
       deleteGeofireMarkers();
     }

     if(statusRide == "ended")
     {
       if(event.snapshot.value["fares"] != null)
       {
         int fare = int.parse(event.snapshot.value["fares"].toString());
         var res = await showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context) => CollectFareDialog(paymentMethod: "cash", fareAmount: fare,),
         );

         String driverId = "";
         if(res == "close")
         {
           if(event.snapshot.value["driver_id"] != null)
           {
             driverId = event.snapshot.value["driver_id"].toString();
           }
             
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RatingScreen(driverId: driverId)));   

           rideRequestRef.onDisconnect();
           rideRequestRef=null;
           rideStreamSubscription.cancel();
           rideStreamSubscription = null;
           resetApp();
         }
       }
     }

    });
 } 

void deleteGeofireMarkers()
{
  setState(() {
    markerSet.removeWhere((element) => element.markerId.value.contains("driver"));
  });
}

void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async
{
   if(isRequestingPositiondetails == false)
   {

    isRequestingPositiondetails = true;

   var positionUserLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
   var details = await AssistantMethods.obtainPlaceDirectionDetails(driverCurrentLocation, positionUserLatLng);
   if(details == null)
   {
     return;
   }
   setState(() {
     rideStatus = "Driver is on the way - "+ details.durationText;
   });
   }

   isRequestingPositiondetails = false;
}

void updateRideTimeToDropOffLoc(LatLng driverCurrentLocation) async
{
   if(isRequestingPositiondetails == false)
   {

    isRequestingPositiondetails = true;

   var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
   var dropOffUserLatLng = LatLng(dropOff.latitude, dropOff.longitude);
   var details = await AssistantMethods.obtainPlaceDirectionDetails(driverCurrentLocation, dropOffUserLatLng);
   if(details == null)
   {
     return;
   }
   setState(() {
     rideStatus = "Going to destination - "+ details.durationText;
   });
   }

   isRequestingPositiondetails = false;
}

void cancelRideRequest()
{
   rideRequestRef.remove();
   setState(() {
        state ="normal";
      });
} 

void displayRideRequestContainer()
{
  setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = true;
    });
  
    saveRideRequest();
}

void displayDriverDetailsContainer()
{
  setState(() {
      requestRideContainerHeight = 0.0;
      rideDetailsContainerHeight = 0.0;
      bottomPaddingOfMap = 290.0;
      driverDetailsContainerheight = 310.0;
    });
}

resetApp()
{
  setState(() {
      drawerOpen = true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230.0;

      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();

      statusRide = " ";
      driverName = " ";
      driverPhone = " ";
      carDetailsDriver = " ";
      rideStatus = "Driver is coming";
      driverDetailsContainerheight = 0.0;
    });

    locatePosition();
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

 static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
   // final user = Provider.of<UserProvider>(context);


    // FutureBuilder(            
    //    future: getPlaceDirection(),//adding your main location widget in future
    //    builder: (context, state) {
    //       if (state.connectionState == ConnectionState.active ||
    //           state.connectionState == ConnectionState.waiting) {
    //           return SpinKitRipple(
    //            itemBuilder: (BuildContext context, int index) {
    //                 return DecoratedBox(
    //                     decoration: BoxDecoration(
    //                     color: index.isEven ? Colors.grey : 
    //                     Color(0xffffb838),
    //                            ),
    //                          );
    //                        },
    //                      );
    //               } 
    //               else {

    //   //here you should write your main logic to be shown once latitude ! = NULL
    //    return Container();
    //    }
    //  }
    //  );
    createIconMarker();
    return Scaffold(
        key: scaffoldKey,
        // appBar: AppBar(
        //   title: Text('Jitney'),
        //   backgroundColor: Colors.orange,
        // ),
        drawer: Container(
          color: white,
          width: 255.0,
          child: Drawer(
            child: ListView(
              children: [
                //DrawerHeader
                Container(
                height: 165.0,
                child: 
                // UserAccountsDrawerHeader(
                // decoration: BoxDecoration(
                //   color: orange,
                //   borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                // ),
                // currentAccountPicture: Icon(Icons.person, color: Colors.white, size: 70,), 
                // accountName: Text(user.userModel?.name ?? "Username loading...",
                // style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                // ),
                // accountEmail: Text(user.userModel?.email ?? "Email loading...",
                // style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),)
                //  ),
    
    
                UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0,)),
                  boxShadow: [
                  BoxShadow(
                    color: black,
                    blurRadius: 7.0,
                    spreadRadius: 0.6,
                    offset: Offset(0.7, 0.7),
                  ),
                ]
                ),
                currentAccountPicture:Icon(Icons.person_outline_outlined, color: Colors.white, size: 70,),
                accountName: Text('uName', 
                style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "Brand Bold"),
                ),
                accountEmail: Text('User email', 
                style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "Brand Bold",),
                ),
               
                ),
    
    
                  // child: DrawerHeader(
                  //   decoration: BoxDecoration(
                  //     color: white,
                  //     ),
                  //   child: Row(
                  //     children: [
                  //       Image.asset("images/user_icon.png", height: 65.0, width: 65.0),
                  //       SizedBox(width: 16.0,),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text("uName", style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),),
                  //           GestureDetector(
                  //             onTap: ()
                  //             {
                  //               // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileTab()));
                  //              },
                  //             child: Text(
                  //               "Visit Profile"
                  //               ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),  
                  //  ), 
                ),
    
                //DividerWidget(),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, ParcelScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("Parcels", style: TextStyle(fontSize: 16.0),),
                  ),
                ),
    
                GestureDetector(
                   onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
                    },
    
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text("History", style: TextStyle(fontSize: 16.0),),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileTab()));
                    },
                    child: Text("Visit Profile", style: TextStyle(fontSize: 16.0),)
                    ),
                ),
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, AboutScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About", style: TextStyle(fontSize: 16.0),),
                  ),
                ),
                GestureDetector(
                  onTap: ()
                  {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text("Sign Out", style: TextStyle(fontSize: 16.0, color: Colors.red),),
                  ),
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
    
            // Search UI
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                    height: searchContainerHeight,
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
                                displayRideDetailsContainer();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(23.0),
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
            ),
            
            //Ride details UI
            Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: black,
                      blurRadius: 16.0,
                      spreadRadius: 0.6,
                      offset: Offset(0.7, 0.7),
                    ),
                  ]
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
      /// jitney ride category
                      GestureDetector(
                        onTap: ()
                        {
                           
                           setState(() {
                               state = "requesting";
                               carRideType = "Jitney";                        
                              });
                                 
                             displayRideRequestContainer();
                             availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                             searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/jitney.png", height: 70.0, width: 80.0),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "J!tney", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : ''), style: TextStyle(fontSize: 18.0, color: grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(
                                      ((tripDirectionDetails != null) ? '\$${(AssistantMethods.calculateFares(tripDirectionDetails))*0.75}': ''), style: TextStyle(fontFamily: "Brand-Bold"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
    
                      SizedBox(height: 10.0,),
                      Divider(height:2.0, thickness:2.0),
                      SizedBox(height: 10.0,),
    
    ///  jitney fam category
                      GestureDetector(
                        onTap: ()
                        {
                           
                           setState(() {
                               state = "requesting";
                               carRideType = "Jitney-Fam";                       
                                  });
                             displayRideRequestContainer();
                             availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                             searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/jitneyfam.png", height: 70.0, width: 80.0),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "J!tney-Fam", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : ''), style: TextStyle(fontSize: 18.0, color: grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(
                                      ((tripDirectionDetails != null) ? '\$${(AssistantMethods.calculateFares(tripDirectionDetails))*0.95}': ''), style: TextStyle(fontFamily: "Brand-Bold"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
    
                      SizedBox(height: 10.0,),
                      Divider(height:2.0, thickness:2.0),
                      SizedBox(height: 10.0,),
    
    //// Jitney Lux category
                      GestureDetector(
                        onTap: ()
                        {
                           
                           setState(()
                              {
                               state = "requesting";
                               carRideType = "Jitney-Lux";                      
                              });
                             displayRideRequestContainer();
                             availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                             searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/jitneylux.png", height: 70.0, width: 80.0),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "J!tney-Lux", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : ''), style: TextStyle(fontSize: 18.0, color: grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(
                                      ((tripDirectionDetails != null) ? '\$${(AssistantMethods.calculateFares(tripDirectionDetails))* 1.2}': ''), style: TextStyle(fontFamily: "Brand-Bold"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
    
                      SizedBox(height: 10.0,),
                      Divider(height:2.0, thickness:2.0),
                      SizedBox(height: 10.0,),
    
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54),
                            SizedBox(width: 6.0,),
                            Text("Cash"),
                            SizedBox(width: 6.0),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16.0,),
    
                          ],
                        ),
                        ),            
                    ],
                  ),
                ),
              ),
            ),
           ),
          
            //Ride request or cancel UI
            Positioned(
             top: 0.0,
             left: 0.0,
             right: 0.0,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                 color: white,
                 boxShadow: [
                   BoxShadow(
                     color: black,
                     blurRadius: 16.0,
                     spreadRadius: 0.6,
                     offset: Offset(0.7, 0.7),    
                   ),
                 ],
               ),
               height: requestRideContainerHeight,
               child: Padding(
                 padding: const EdgeInsets.all(30.0),
                 child: Column(
                   children: [
                      SizedBox(height: 12.0,),
    
                      SizedBox(
                        height: 200.0,
                        child: WavyAnimatedTextKit(
                            textStyle: TextStyle(
                                   fontSize: 40.0,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: "Canterbury"
                              ),
                               text: [
                                    "Requesting your ride...",
                                    "please wait...",
                                    "Finding your driver",                              
                                      ],
                             isRepeatingAnimation: true,
                            ),
                      ),
                      SizedBox(height: 22.0,),
    
                      GestureDetector(
                        onTap: ()
                        {
                          cancelRideRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(26.0),
                            border: Border.all(width: 2.0, color: Colors.black54),
                          ),
                          child: Icon(Icons.close, size: 26.0),
                        ),
                      ),
    
                      SizedBox(height: 10.0,),
    
                      Container(
                        width: double.infinity,
                        child: Text("Cancel Ride", textAlign: TextAlign.center,
                        style:  TextStyle(fontSize: 12.0),
                        ),
                      ),
    
                   ],
                 ),
               ),
             ),
           ),
          
            // display assigned driver info
            Positioned(
             top: 0.0,
             left: 0.0,
             right: 0.0,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                 color: white,
                 boxShadow: [
                   BoxShadow(
                     color: black,
                     blurRadius: 16.0,
                     spreadRadius: 0.6,
                     offset: Offset(0.7, 0.7),    
                   ),
                 ],
               ),
               height: driverDetailsContainerheight,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      SizedBox(height: 6.0,),
    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(rideStatus, textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontFamily: "Brand-bold",),),
                        
                        
                        ],
                      ),
                      SizedBox(height: 22.0),
    
                      Divider(height: 2.0, thickness: 2.0,),
    
                      SizedBox(height: 22.0),
    
                      Text(carDetailsDriver, style: TextStyle(color: Colors.grey,)),
    
                      Text(driverName, style: TextStyle(fontSize: 20.0)),
    
                      SizedBox(height: 22.0),
    
                      Divider(height: 2.0, thickness: 2.0,),
    
                      SizedBox(height: 22.0),
    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal:20.0),
                           // ignore: deprecated_member_use
                           child: RaisedButton(
                             onPressed: ()
                             {                             
                               launch(('tel://$driverPhone'));
                             },
                             color: Colors.green,
                             child: Padding(
                               padding:EdgeInsets.all(17.0),
                               child:Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   Text('Call Driver', 
                                   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                                   ),
                                   Icon(Icons.call, color:Colors.white, size: 26.0),
                                 ],
                               ),
                             ),
                           ),
                         ),
                        ],
                      ),
                   ],
                 ),
               ),
            ),
           ),
          ],
        ),
    );
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

  void createIconMarker()
  {
    if( nearbyIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      //adding the drivers car image icon
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
      .then((value)
      {
        nearbyIcon = value;
      } );

    }
  }

  void noDriverFound()
  {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) => NoDriverAvailableDialog(),
      );
  }

  void searchNearestDriver()
  {
    if(availableDrivers.length == 0)
    {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = availableDrivers[0];
    driversRef.child(driver.key).child("car_details").child("type").once().then((DataSnapshot snap) async
    {
       if(await snap.value != null)
       {
         String carType = snap.value.toString();
         if(carType == carRideType)
         {
           notifyDriver(driver);
           availableDrivers.removeAt(0);
         }
         else
         {
           displayToastMessage(carRideType + " not found. Try again later" , context);
         }
       }
       else
         {
           displayToastMessage(carRideType + " not found. Try again later" , context);
         }
    });
    
  }

  void notifyDriver(NearbyAvailableDrivers driver)
  {
    driversRef.child(driver.key).child("newRide").set(rideRequestRef.key);

    driversRef.child(driver.key).child("token").once().then((DataSnapshot snap){
      if(snap.value != null)
      {
         String token = snap.value.toString();
         AssistantMethods.sendNotificationToDriver(token, context, rideRequestRef.key);
      }
      else
      {
        return;
      }

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer){

        if(state != "requesting")
        {
          driversRef.child(driver.key).child("newRide").set("cancelled");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 50;
          timer.cancel();
        }
        driverRequestTimeOut = driverRequestTimeOut - 1;

        driversRef.child(driver.key).child("newRide").onValue.listen((event){
          if(event.snapshot.value.toString() == "accepted")
          {
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 50;
          timer.cancel();
          }
        });
        
        if(driverRequestTimeOut == 1)
        {
          driversRef.child(driver.key).child("newRide").set("timeout");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 50;
          timer.cancel();
          searchNearestDriver();
        }
       });
    });
  }

} 