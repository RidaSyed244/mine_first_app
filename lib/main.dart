import 'package:flutter/material.dart';
import 'package:mine_first_app/dashboard.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'create_account.dart';
// import 'forgot_password.dart';
// import 'profile.dart';

Future<void> main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(MaterialApp(
     debugShowCheckedModeBanner :false,
    home: email == null ? LogIn() : Dashboard()));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: ThemeData.light().copyWith(
//           iconTheme: IconThemeData(color: Colors.black),
//         ),
//         initialRoute: Profile.id,
//         routes: {
//           CreateAccount.id: (context) => CreateAccount(),
//           LogIn.id: (context) => LogIn(),
//           ImageScreen.id: (context) => ImageScreen(),
//           ForgotPswrd.id: (context) => ForgotPswrd(),
//           Profile.id: (context) => Profile(),
//         });
//   }
// }
