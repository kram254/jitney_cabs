import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitney_cabs/src/assistants/requestAssistant.dart';
import 'package:jitney_cabs/src/helpers/configMaps.dart';
import 'package:jitney_cabs/src/models/address.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:provider/provider.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response  = await RequestAssistant.getRequest(url);

    if(response != "failed")
    {
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st3 = response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];

      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen:  false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  } 

void obtainPlaceDirectionDetails (LatLng initialPosition, LatLng finalPosition) async
{
  String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

  var res = await RequestAssistant.getRequest(directionUrl);

  if(res == "failed")
  {
    return;
  }
}

}