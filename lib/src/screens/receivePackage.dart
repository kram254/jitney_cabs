import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/screens/SelectPackagePickUp.dart';

class RecievePackage extends StatefulWidget {
  //const RecievePackage({ Key? key }) : super(key: key);

  @override
  _RecievePackageState createState() => _RecievePackageState();
}

class _RecievePackageState extends State<RecievePackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orange,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage("images/package-delivery.png"),
              height: MediaQuery.of(context).size.height * 0.4,
              width: 300.0,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Text(
                "Please, enter the phone number of the person sending the package",
                style: TextStyle(
                    color: black,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Brand bold"),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'KE',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
            ),
            SizedBox(
              height: 80.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectPackagePickUp()));
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                primary: black,
                onPrimary: orange,
                shadowColor: grey,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 5.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
