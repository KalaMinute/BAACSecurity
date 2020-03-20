import 'package:baacsecurity/screen/authen.dart';
import 'package:baacsecurity/screen/my_service.dart';
import 'package:baacsecurity/screen/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Method
  // ตรวจสอบสถานะว่า login ค้างอยู่หรือไม่ ถ้าค้างอยู่จะเด้งไปหน้า Myservice เลย
  // โดยการไปสอบถามที่ Firebase
  // Method นี้จะทำงานก่อน build
  @override
  void initState() {
    super.initState();
    checkStatus(); 
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Myservice());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  Widget signUpButtom() {
    return OutlineButton(
      child: Text('Sign Up',style: TextStyle(color: Colors.green.shade700),),
      onPressed: () {
        print('You Click Sign Up');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget signInButtom() {
    return RaisedButton(
      color: Colors.green.shade700,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Authen());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButtom() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInButtom(),
        SizedBox(
          width: 20.0,
        ),
        signUpButtom(),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'BAAC Security System Alert',
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.green.shade700,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.white, Colors.orange.shade400],
            radius: 0.5,
          )),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                SizedBox(
                  height: 15.0,
                ),
                showAppName(),
                SizedBox(
                  height: 25.0,
                ),
                showButtom(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
