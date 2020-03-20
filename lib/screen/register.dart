import 'package:baacsecurity/screen/my_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString, branchString;

  //Method
  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.green,
          size: 35.0,
        ),
        labelText: 'Display Name :',
        labelStyle: TextStyle(
          color: Colors.green,
        ),
        helperText: 'Type Your Name',
        helperStyle: TextStyle(
          color: Colors.green,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name and Lastname';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(
          Icons.alternate_email,
          color: Colors.yellow.shade700,
          size: 35.0,
        ),
        labelText: 'Email :',
        labelStyle: TextStyle(
          color: Colors.yellow.shade700,
        ),
        helperText: 'Type Your Email',
        helperStyle: TextStyle(
          color: Colors.yellow.shade700,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value2) {
        if (!((value2.contains('@baac')) && (value2.contains('.')))) {
          return 'Please Type Your Email';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.trim();
      },
    );
  }

  Widget passText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock_open,
          color: Colors.blue,
          size: 35.0,
        ),
        labelText: 'Passsword :',
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        helperText: 'Type Your Password',
        helperStyle: TextStyle(
          color: Colors.blue,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value3) {
        if (value3.length < 8) {
          return 'Password More 8 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value.trim();
      },
    );
  }

  // ใส่สาขา
  Widget branchText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.home,
          color: Colors.orange,
          size: 35.0,
        ),
        labelText: 'Branch :',
        labelStyle: TextStyle(
          color: Colors.orange,
        ),
        helperText: 'Type Your Branch',
        helperStyle: TextStyle(
          color: Colors.orange,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value4) {
        if (value4.isEmpty) {
          return 'Please Fill Your Branch';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        branchString = value.trim();
      },
    );
  }

  // ปุ่มกดลงทะเบียน
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('You Click Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'name = $nameString,email = $emailString,password = $passwordString,branch = $branchString');
          // ตอนนี้เราะจะมีค่าต่างๆ ครบแล้ว เพื่อที่จะเอาไปลงทะเบียน ไปทำงานที่รีจีสเตอร์แทรด
          registerThread();
        }
      },
    );
  }

  //สร้างแทรดเชื่อมกับ firebase เพื่อรับ email กับ password
  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance; //สร้าง Instance เพื่อใช้งานกับ Firebase
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString) //ส่ง email กับ password ไปเก็บใน firebase
        .then((response) {
      print('Register Success For Email =$emailString'); // ถ้าสมัครได้แล้วให้เก้บไว้ในตัว respons แล้วลอง print มาดู
      setupDisplayName();
    }).catchError((response) { // ถ้าไม่สำเสร็จ จะส่งค่ากลับมาในตัวแปล respons
      String title = response.code;
      String message = response.message;
      print('title = $title,message = $message');
      myAlert(title, message);
    });
  }

 //สร้างแทรดเชื่อมกับ firebase 
  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance; //สร้าง Instance เพื่อใช้งานกับ Firebase
    await firebaseAuth.currentUser().then((response) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nameString;
      response.updateProfile(userUpdateInfo);

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Myservice());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

 
  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        title: Text('Register'),
        actions: <Widget>[registerButton()],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(40.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passText(),
            branchText(),
          ],
        ),
      ),
    );
  }
}
