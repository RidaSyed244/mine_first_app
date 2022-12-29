import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPswrd extends StatefulWidget {
  static const String id = 'forgot_password';
  @override
  State<ForgotPswrd> createState() => _ForgotPswrdState();
}

class _ForgotPswrdState extends State<ForgotPswrd> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LogIn()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Forgot your Password?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
         padding: const EdgeInsets.fromLTRB(38, 150, 38, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('No Worries!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 40.0),
            Text('Fill the email and send request to \nreset your password.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                )),
            SizedBox(height: 40.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Email*",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
            TextField(
              controller: emailController,
              onChanged: (value) {},
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  )),
            ),
            SizedBox(height: 40.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                child: MaterialButton(
                  onPressed: () {
                    try {
                      final reset = _auth.sendPasswordResetEmail(
                          email: emailController.text);
                      if (reset != null) {
                        final resett = Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  minWidth: 240.0,
                  height: 10.0,
                  child: Text('Send Request',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      )),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
