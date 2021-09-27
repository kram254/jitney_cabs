import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
// import 'package:jitney_cabs/src/assistants/requestAssistant.dart';
// import 'package:jitney_cabs/src/helpers/configMaps.dart';

class SelectPackageDropOff extends StatefulWidget {

  @override
  _SelectPackageDropOffState createState() => _SelectPackageDropOffState();
}

class _SelectPackageDropOffState extends State<SelectPackageDropOff> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
 Set<Polyline> polylineSet = {};
 Set<Marker> markerSet = {};
 Set<Circle> circleSet = {};
 double bottomPaddingOfMap = 0;
 
 Completer<GoogleMapController> _controllerGoogleMap = Completer();
 GoogleMapController newGoogleMapController;

 static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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

             

             Positioned(
               top:50.0,
               
               child: Expanded(
                 child: Row(
                   children: [
                     Expanded(
                       child: SizedBox(
                         height: 40.0,
                         
                         child: TextField(
                         controller: _controller,
                         
                         onTap: () async 
                         {
                           // placeholder for our places search later
                         },
                            // with some styling
                         decoration: InputDecoration(
                            icon: Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 10,
                            height: 10,
                            child: Icon(
                                       Icons.search_outlined,
                                       color: orange,
                                     ),
                                 ),
                         hintText: "Search drop-off location",
                         border: InputBorder.none,
                         contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                               ),
                             ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
        ],
      ),
      
    );
  }
}

// void pickPlace (String placeName) async
// {
//   if(placeName.length>1)
//   {
//     String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ke";
    
//     var res = await RequestAssistant.getRequest(autoCompleteUrl);

//     if (res == "failed") 
//     {
//       return;
//     }
//   }
// }