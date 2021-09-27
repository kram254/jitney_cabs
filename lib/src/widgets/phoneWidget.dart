import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class PhoneWidget extends StatefulWidget {
  @override
  _PhoneWidgetState createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends State<PhoneWidget> {
  String _selectedCountryCode;
  List<String> _countryCodes = ['+91', '+23',];

  @override
  Widget build(BuildContext context) {
    var countryDropDown = Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(width: 0.5, color: Colors.grey),
        ),
      ),
      height: 45.0,
      margin: const EdgeInsets.all(3.0),
      //width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _selectedCountryCode,
            items: _countryCodes.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(
                    value,
                    style: TextStyle(fontSize: 12.0),
                  ));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCountryCode = value;
              });
            },
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
    return Container(
      width: double.infinity,
      margin: new EdgeInsets.only(top: 10.0, bottom: 10.0, right: 3.0),
      color: Colors.white,
      child: new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
        },
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
            contentPadding: const EdgeInsets.all(12.0),
            border: new OutlineInputBorder(
                borderSide:
                    new BorderSide(color: const Color(0xFFE0E0E0), width: 0.1)),
            fillColor: Colors.white,
            prefixIcon: countryDropDown,
            hintText: 'Phone Number',
            labelText: 'Phone Number'),
      ),
    );
  }
}