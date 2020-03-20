import 'package:baacsecurity/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Myservice extends StatefulWidget {
  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  // Explicite

  //Method
  Widget signOutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sign Out',
      onPressed: () {
        myAlert();
      },
    );
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are You Sure'),
            content: Text('Do You Want Sing Out ?'),
            actions: <Widget>[
              cancelButton(),
              okButton(),
            ],
          );
        });
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
        processSignOut();
      },
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
        actions: <Widget>[signOutButton()],
      ),
      body: Text('Body'),
    );
  }
}
