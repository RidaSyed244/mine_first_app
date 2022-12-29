import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mine_first_app/api_images.dart';
import 'profile.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Drawer(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          snapshot.data?.data()?["displayname"],
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        accountEmail: Text(
                          snapshot.data?.data()?["email"],
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        currentAccountPicture: CircleAvatar(
                          child: ClipOval(
                            child: snapshot.data.data()?["profileimage"] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(55)),
                                    width: 100,
                                    height: 100,
                                  )
                                : CircleAvatar(
                                    radius: 55,
                                    backgroundImage: NetworkImage(
                                        snapshot.data?.data()?["profileimage"]),
                                  ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqQMwq_mZ2I9qpXPhmIeJ5on2jZTavrF65Kw&usqp=CAU"),
                                fit: BoxFit.cover)),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        title: Text("Profile"),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile())),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.dashboard,
                          color: Colors.black,
                        ),
                        title: Text("Dashboard"),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageScreen())),
                      ),
                      ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          title: Text("Log_Out"),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('email');
                            _signout(context);
                          }),
                    ],
                  );
                } else {
                  return SpinKitSpinningLines(
                      size: 100, color: Color(0xFF25315B));
                }
              })),
    );
  }

  Future<void> _signout(BuildContext context) async {
    final signout = await _auth.signOut().then((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
    });
  }
}
