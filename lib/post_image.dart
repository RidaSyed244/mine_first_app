import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mine_first_app/dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;
import 'dart:io';
import 'package:path/path.dart';

class PostImages extends StatefulWidget {
  const PostImages({super.key});

  @override
  State<PostImages> createState() => _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final TextEditingController postImageText = TextEditingController();
  final TextEditingController postImage = TextEditingController();
  String imageUrl = '';
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            'Create Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Input Description",
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
                maxLines: 5,
                controller: postImageText,
                onChanged: (value) {},
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    hintText: "   Write here something!",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Image",
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
                controller: postImage,
                onChanged: (value) {},
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        onPressed: () => _showpicker(context)),
                    hintText: "Image",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 19),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GestureDetector(
                  onTap: () async {
                     takephoto(context);
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update({
                          'postImageText': postImageText.text,
                        })
                        .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard())))
                        .catchError(
                            (error) => print("Failed to add user: $error"));

                   
                  },
                  child: Container(
                    height: 50,
                    width: 240,
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.white)],
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2), width: 1.0),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "Create Post",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),

           
              )
            ],
          ),
        ));
  }

  

  void _showpicker(context) {
    showModalBottomSheet(
        context: context, builder: ((builder) => BottomSheet(context)));
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'PostImages/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  File? _photo;

  final ImagePicker _picker = ImagePicker();
  Future takephoto(BuildContext context) async {
    String fileName = basename(_photo!.path);
    final destination = 'PostImages/$fileName';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(destination).child('file');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(_photo!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      print(imageUrl);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'postImage': imageUrl,
      });
    } catch (e) {
      print(e);
    }
  }

  Widget BottomSheet(context) {
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
                "Choose Photo",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.camera, color: Colors.black),
                  onPressed: () => {
                    imgFromCamera(),
                    Navigator.of(context).pop(),
                  },
                  label: Text("Camera", style: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  width: 40.0,
                ),
                TextButton.icon(
                  icon: Icon(Icons.image, color: Colors.black),
                  onPressed: () =>
                      {imgFromGallery(), Navigator.of(context).pop()},
                  label: Text("Gallery", style: TextStyle(color: Colors.black)),
                ),
              ],
            )
          ]),
    );
  }
}
   