import 'package:flutter/cupertino.dart';
import 'package:jitney_cabs/src/models/address.dart';

class AppData extends ChangeNotifier
{
  Address pickUpLocation;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}