import 'package:baacsecurity/screen/my_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  //Explicit
  final formKey = GlobalKey<FormState>();
  String emailString, passwordString;

  //Method
  Widget backButton() {
    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        size: 48.0,
        color: Colors.green.shade700,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

/////////////////////////////////////////////
  Widget showAppName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[showLogo(), showText()],
    );
  }

  Widget showLogo() {
    return Container(
      width: 36.0,
      height: 36.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showText() {
    return Text(
      '  BAAC Security System Alaert',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade700,
      ),
    );
  }

//////////////////////////////////////////////////////////

  Widget emailText() {
    return Container(
      width: 260.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 40.0,
            color: Colors.green.shade700,
          ),
          labelText: 'Email :',
          labelStyle: TextStyle(
            color: Colors.green.shade700,
          ),
        ),
        onSaved: (String value) {
          emailString = value.trim();
        },
      ),
    );
  }

  //////////////////////////////////////////////////////////////

  Widget passwordText() {
    return Container(
      width: 260.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock_open,
            size: 40.0,
            color: Colors.green.shade700,
          ),
          labelText: 'Password :',
          labelStyle: TextStyle(
            color: Colors.green.shade700,
          ),
        ),
        onSaved: (String value) {
          passwordString = value.trim();
        },
      ),
    );
  }

///////////////////////////////////////////////////////
  Widget content() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showAppName(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }
//////////////////////////////

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Authen Success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Myservice());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      myAlert(title, message);
    });
  }

 //////////////////////////////////////////////
  Widget okButton() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

 Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 48.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showTitle(title),
            content: Text(message),
            actions: <Widget>[okButton()],
          );
        });
  }

  ////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Colors.white, Colors.orange.shade400], radius: 0.5)),
          child: Stack(
            children: <Widget>[
              backButton(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        child: Icon(
          Icons.navigate_next,
          size: 30.0,
        ),
        onPressed: () {
          formKey.currentState.save();
          print('Email = $emailString,password = $passwordString');
          checkAuthen();
        }, 
      ),
    );
  }
}
