import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/assistants/requestAssistant.dart';
import 'package:jitney_cabs/src/helpers/configMaps.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/models/address.dart';
import 'package:jitney_cabs/src/models/placePredictions.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:jitney_cabs/src/screens/checkoutScreen.dart';
import 'package:jitney_cabs/src/widgets/Divider.dart';
import 'package:jitney_cabs/src/widgets/progressDialog.dart';
import 'package:provider/provider.dart';

class PackageSearchScreen extends StatefulWidget {
 // const PackageSearchScreen({ Key? key }) : super(key: key);

  @override
  _PackageSearchScreenState createState() => _PackageSearchScreenState();
}

class _PackageSearchScreenState extends State<PackageSearchScreen> {
   
   
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
   
  //initializing the list
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.45,
              
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20), ),
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
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[400],
                              boxShadow: [ BoxShadow(
                                 
                                 //blurRadius: 6.0,
                                 //spreadRadius: 0.6,
                                 offset: Offset(
                                    0.7, 0.7
                                     ),
                                  ),
                              ]
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: black,
                              ),
                          ),
                        ),
                        Center(
                          child: Text("Set your package drop-off", style: TextStyle(color: black,fontSize: 18.0, fontFamily: "Brand-Bold"),),
                        ),
                      ],
                    ),
      
                    SizedBox(height: 26.0,),
                    Row(
                      children: [
                        Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[400],
                              boxShadow: [ BoxShadow(
                                 
                                 //blurRadius: 6.0,
                                 //spreadRadius: 0.6,
                                 offset: Offset(
                                    0.7, 0.7
                                     ),
                                  ),
                              ]
                            ),

                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("images/pickicon.png", height: 16.0,width: 16.0),
                          ),
                          ),
      
                        //SizedBox(height: 18.0,),

                        SizedBox(width: 15.0,),
                        
                        Expanded(
                          child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(35.0),
      
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Pick-up location",
                                //fillColor: Colors.grey[500],
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
                    SizedBox(height: 40.0,),
                    Row(
                      children: [
                        Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[400],
                              boxShadow: [ BoxShadow(
                                 
                                 //blurRadius: 6.0,
                                 //spreadRadius: 0.6,
                                 offset: Offset(
                                    0.7, 0.7
                                     ),
                                  ),
                              ]
                            ),

                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("images/desticon.png", height: 16.0,width: 16.0),
                          ),
                          ),

                        SizedBox(width: 15.0,),
                        
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(35.0),
      
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                //fillColor: Colors.grey[500],
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
            ),
            //tile for displaying the predictions
            SizedBox(height: 10.0,),
            
           (placePredictionList.length > 0)
           ? Padding(
             padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
             child: ListView.separated(
               padding: EdgeInsets.all(0.0),
               itemBuilder: (context, index)
               {
                 return PredictionTile(placePredictions: placePredictionList[index],);
               },
               separatorBuilder: (BuildContext context, int index) => DividerWidget() ,
               itemCount: placePredictionList.length,
               shrinkWrap: true,
               physics: ClampingScrollPhysics(),
              )
             )

           : Container(),

           SizedBox(height: MediaQuery.of(context).size.height*0.1,),

          ElevatedButton(
              onPressed: ()
              {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
              },
              child:Text('Next'),
              style: ElevatedButton.styleFrom(
                primary:orange,
                onPrimary: black,
                shadowColor: grey,
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 5.0,
              ),
              
            ),
          ],
          ),
      ),
  
    );
  }

  void findPlace(String placeName) async
  {
    if (placeName.length>1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ke";

       var res = await RequestAssistant.getRequest(autoCompleteUrl);
       if(res == "failed")
       {
         return;
       }
      
       if(res["status"] == "OK")
       {
         var predictions = res["predictions"];

         var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
         setState(() {
                    placePredictionList = placesList;
                  });
       }
    }
  }
}

class PredictionTile extends StatelessWidget {

  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child:  Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(width: 14.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0,),
                    Text(placePredictions.name_text ?? " ", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                    SizedBox(height: 4.0,),
                    Text(placePredictions.secondary_text ?? " ", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: grey),),
                    SizedBox(height: 10.0,),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(width: 10.0,),
          ],
        ),
        
      ),
    );
  }

  void getPlaceAddressDetails( String placeId, context) async
  {
      showDialog(
        context: context, 
        builder: (BuildContext context) => ProgressDialog(message: "Relax while we set your drop-off for your package...",),
        );

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
  
    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if(res == "failed")
    {
      return;
    }

    if(res["status"] == "OK")
    {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude= res["result"]["geometry"]["location"]["lat"];
      address.latitude= res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen:false).updateDropOffLocationAddress(address);
      print("This is the drop-off location :");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}