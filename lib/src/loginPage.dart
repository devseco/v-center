import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecommerce/src/signup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../Pages/Home.dart';
import '../api/connect.dart';
import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}
late SharedPreferences prefs;
bool loading = false;
TextEditingController _phone = new TextEditingController();
TextEditingController _password = new TextEditingController();
class _LoginPageState extends State<LoginPage> {


  Widget _entryField(String title, TextEditingController textEditingController ,{bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xfff3f3f4),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: textEditingController,
                obscureText: isPassword,
                decoration: const InputDecoration(
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
        if(_phone.text.isNotEmpty && _password.text.isNotEmpty){
          login();
        }else{

        }

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: const Text(
          'تسجيل دخول',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
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
            builder: (BuildContext context) => SignUpPage(),
          ),
              (Route route) => false,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'اذا كنت لا تمتلك حساب',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'تسجيل ؟',
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
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "رقم الهاتف",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff3f3f4),
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
                    decoration: const InputDecoration(
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
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "كلمة السر",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff3f3f4),
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
                    decoration: const InputDecoration(
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
  void initState() {
    // TODO: implement initState
    super.initState();
    ()async{
      _phone.text = "";
      _password.text = "";
      prefs = await SharedPreferences.getInstance();
      if(prefs.getString("id") != "" && prefs.getString("id") != null){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => const Home(),
            ),
                (Route route) => false,
          );
      }else{
        //Navigator.pop(context);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Directionality(textDirection: TextDirection.rtl, child:
    Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child:  IconButton(
            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(FontAwesomeIcons.whatsapp , color: Colors.green,size: height * 0.04,),
              onPressed: () {

                launchWhatsAppUri();

              }
          ),
        ),
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: height * .2),
                      _title(),
                      const Text("V-Center" , style:TextStyle(
                        fontSize: 17
                      )),
                      const SizedBox(height: 30),
                      _emailPasswordWidget(),
                      const SizedBox(height: 20),
                      (loading)? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: const Color(0xfffbb448),
                            size: 50,
                          )) : _submitButton(),
                      _divider(),
                      const SizedBox(height: 10),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
  void login() async {
    setState(() {
      loading = true;
    });
    var url1 = Uri.parse(
        Apis.Api  + 'login.php?phone='+ _phone.text.toString() + '&password=' + _password.text.toString()
    );
    http.Response response = await http.get(url1);
    var data = json.decode(response.body);
    if(data.toString().contains("غير مفعل")){
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        title: "الحساب غير مفعل",
        type: QuickAlertType.warning,
        text: 'يرجى التواصل مع الدعم الفني لتاكيد حسابك',
      );
      setState(() {
        loading = false;
      });
    }else if(data.toString().contains("رقم الهاتف")){
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        type: QuickAlertType.error,
        title: 'مشكلة في تسجيل الدخول',
        text: 'تاكد من المعلومات المدخلة',
      );
      setState(() {
        loading = false;
      });
    }else if(data.toString().contains("name")){
      SharedPreferences sharedPreferences = await  SharedPreferences.getInstance();
      sharedPreferences.setString("id", data["id"]);
      sharedPreferences.setString("name", data["name"]);
      sharedPreferences.setString("phone", data["phone"]);
      sharedPreferences.setString("address", data["address"]);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        ),
            (Route route) => false,
      );
      setState(() {
        loading = false;
      });

    }else{
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        type: QuickAlertType.error,
        title: 'مشكلة في تسجيل الدخول',
        text: 'تاكد من المعلومات المدخلة',
      );
      setState(() {
        loading = false;
      });
    }


  }
  launchWhatsAppUri() async {
    final link = const WhatsAppUnilink(
      phoneNumber: '+9647752855594',
      text: "Hey! I'm inquiring about the apartment listing",
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launch(link.asUri() as String);
  }
}
