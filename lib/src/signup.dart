import 'dart:convert';

import 'package:ecommerce/Pages/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/src/Widget/bezierContainer.dart';
import 'package:ecommerce/src/loginPage.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../api/connect.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _phone = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  Position? _currentPosition;
  LatLng _alhuria = LatLng(33.3541760,44.3394170);
  LatLng _zafrania = LatLng(33.26082, 44.49870);
  LatLng _adhamya = LatLng(33.36961, 44.36373);
  String _closestPoint = '';
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  void _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _findClosestPoint();
    });
  }
  double _calculateDistance(LatLng point) {
    if (_currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          point.latitude,
          point.longitude);
      print( _currentPosition!.latitude.toString() + " " + _currentPosition!.longitude.toString());
      return distanceInMeters;
    }
    return double.infinity; // Return infinity if position is null
  }
  void _findClosestPoint() {
    double minDistance = double.infinity;
    String closest = '';
    final Map<String, LatLng> points = {
      'الحرية': _alhuria,
      'الزعفرانية': _zafrania,
      'الاعظمية': _adhamya,
    };

    points.forEach((key, value) {
      double distance = _calculateDistance(value);
      if (distance < minDistance) {
        minDistance = distance;
        closest = key;
      }
    });

    setState(() {
      _closestPoint = closest;
    });
  }
  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xfff3f3f4),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                obscureText: isPassword,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _submitButton() {
    return GestureDetector(
      onTap: () {

        if(_name.text.isNotEmpty && _phone.text.isNotEmpty && _address.text.isNotEmpty && _password.text.isNotEmpty  ){

          register(_currentPosition!.latitude,_currentPosition!.longitude);
        }

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          'تسجيل',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );

  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('أو'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
              (Route route) => false,
        );
      },

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'اذا كنت تمتلك حساب',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'تسجيل دخول ؟',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Image.asset("assets/images/logo.png" , width: 200, height: 180, fit: BoxFit.cover,) ;
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "الاسم الكامل",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff3f3f4),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _name,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "رقم الهاتف",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff3f3f4),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _phone,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "العنوان",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff3f3f4),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _address,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "كلمة السر",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff3f3f4),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Directionality(textDirection: TextDirection.rtl, child:
    Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchWhatsAppUri();
        },
        child:  IconButton(
          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
            icon: FaIcon(FontAwesomeIcons.whatsapp , color: Colors.green,size: height * 0.04,),
            onPressed: () { print("Pressed"); }
        ),
      ),
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      Text("V-Center" , style:TextStyle(
                          fontSize: 17
                      )),
                      SizedBox(height: 30),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      Text(
                        'اقرب مزود لك هو فرع : $_closestPoint',
                      ),
                      SizedBox(height: 10),
                      (_isloading)? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: const Color(0xfffbb448),
                            size: 50,
                          )) : _submitButton(),

                      _divider(),
                      SizedBox(height: 10),
                       _createAccountLabel(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
  void register(double lat, double lon) async {
    setState(() {
      _isloading = true;
    });
    final loc = '$lat,$lon';

    var url1 = Uri.parse(
        Apis.Api  + 'register.php?phone='+ _phone.text.toString() + '&password=' +
            _password.text.toString() + '&name='+_name.text.toString().trim() +
            '&address='+_address.text.toString().trim() + '&near='+_closestPoint + '&location='+loc.toString());
    http.Response response = await http.get(url1);
    var data = json.decode(response.body);
    print(data);
    if(data.toString().contains("Phone")){
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        type: QuickAlertType.error,
        title: 'مشكلة في رقم الهاتف',
        text: 'تاكد من المعلومات المدخلة',
      );
      setState(() {
        _isloading = false;
      });
    }else if(data.toString().contains("Successfully")){
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        type: QuickAlertType.success,
        title: 'تمت العملية بنجاح',
        text: 'يرجى التواصل مع الدعم الفني لتفعيل الحساب',
      );
      setState(() {
        _isloading = false;
        _password.clear();
        _phone.clear();
        _address.clear();
        _name.clear();
      });
    }else{
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        type: QuickAlertType.error,
        title: 'مشكلة في تسجيل الحساب',
        text: 'حدث خطآ ما',
      );
      setState(() {
        _isloading = false;
      });
    }


  }

  launchWhatsAppUri() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+9647752855594',
      text: "Hey! I'm inquiring about the apartment listing",
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launch(link.asUri() as String);
  }
  //'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
}
