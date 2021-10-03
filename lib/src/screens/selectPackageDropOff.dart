import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/services/places_service.dart';
import 'package:jitney_cabs/src/widgets/address_search.dart';
import 'package:uuid/uuid.dart';
//import 'package:uuid/uuid.dart';
// import 'package:jitney_cabs/src/assistants/requestAssistant.dart';
// import 'package:jitney_cabs/src/helpers/configMaps.dart';

class SelectPackageDropOff extends StatefulWidget {

  @override
  _SelectPackageDropOffState createState() => _SelectPackageDropOffState();
}

class _SelectPackageDropOffState extends State<SelectPackageDropOff> {
  final _controller = TextEditingController();
  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';

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
               left: 0.0,
               right: 0.0,
               bottom: 0.0,
               child: Container(
                 height: 245.0,
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
                        ]
                      ),
                 )
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
            RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Select here",
              style: TextStyle(fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              //location picker
              
            },
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