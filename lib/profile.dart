import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  static const String id = 'profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String imageUrl = '';

  String ?dropdownvalue;
  var items = [
    'Matric',
    'Intermediate',
    'Bachelors',
    'Masters',
    'Ph.D',
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              color: Colors.black,
              onPressed: () {
 Navigator.of(context).pop();
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => NavBar()));
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("View Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold))),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(38, 25, 38, 0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  print(FirebaseAuth.instance.currentUser?.uid);
                  if (snapshot.hasData) {
                    return ListView(children: [
                      SizedBox(height: 20.0),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _showpicker(context);
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey,
                            child: snapshot.data?.data()?["profileimage"] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 55,
                                    backgroundImage: NetworkImage(
                                        snapshot.data?["profileimage"]),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: emailController,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({"email": emailController.text});
                          await FirebaseAuth.instance.currentUser
                              ?.updateEmail(emailController.text);
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                            hintText: snapshot.data?["email"],
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            )),
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Full Name",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: nameController,
                        onChanged: (value) {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({
                            "displayname": nameController.text,
                          });
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintText: snapshot.data?["displayname"],
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            )),
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: phoneController,
                        onChanged: (value) {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({
                            "displayphoneNumber": phoneController.text,
                          });
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            hintText: snapshot.data?["displayphoneNumber"],
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            )),
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Bio",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        minLines: 1,
                        maxLines: 5,
                        controller: bioController,
                        onChanged: (value) {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({
                            "displayBio": bioController.text,
                          });
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintText: snapshot.data?.data()?["displayBio"],
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            )),
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Study",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton(
                            hint: snapshot.data?.data()?["studydisplay"] == true
                                ? Text("Choose any option: ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19))
                                : Text(snapshot.data?["studydisplay"], style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                            style: TextStyle(color: Colors.white, fontSize: 19),
                            dropdownColor: Colors.black,
                            isExpanded: true,
                            value: dropdownvalue,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              dropdownvalue = newValue;
    
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .update({"studydisplay": newValue});
                            }),
                      )
                    ]);
                  } else {
                    return SpinKitSpinningLines(
                        size: 100, color: Color(0xFF25315B));
                  }
                }),
          ),
        ),
      ),
    );
  }

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  void takephoto(ImageSource sourse) async {
    final pickedFile = await _picker.pickImage(source: sourse);
    if (pickedFile == null) return;
    String uniquefilename = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceroot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceroot.child('images');
    Reference referenceImagetoUpload = referenceDirImages.child(uniquefilename);
    try {
      await referenceImagetoUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImagetoUpload.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "profileimage": imageUrl,
      });
    } catch (e) {}
    setState(() {
      _imageFile = pickedFile as PickedFile;
    });
  }

 
  void _showpicker(context) {
 
    showModalBottomSheet(
        context: context, builder: ((builder) => BottomSheet()));
 
  }

  Widget BottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Choose Profile Photo",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.camera, color: Colors.black),
                  onPressed: () => {takephoto(ImageSource.camera)},
                  label: Text("Camera", style: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  width: 40.0,
                ),
                TextButton.icon(
                  icon: Icon(Icons.image, color: Colors.black),
                  onPressed: () => {takephoto(ImageSource.gallery)},
                  label: Text("Gallery", style: TextStyle(color: Colors.black)),
                ),
              ],
            )
          ]),
    );
  }
}

