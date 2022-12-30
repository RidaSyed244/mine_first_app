import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mine_first_app/dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;
import 'dart:io';
import 'package:path/path.dart';

class PostVideo extends StatefulWidget {
  const PostVideo({super.key});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final TextEditingController postVideoText = TextEditingController();
  final TextEditingController postVideo = TextEditingController();
  String videoUrl = '';
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
                controller: postVideoText,
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
                    "Video",
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
                controller: postVideo,
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
                    hintText: "Video",
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
                    try {
                      await takevideo(context);
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({
                            'postVideoText': postVideoText.text,
                          })
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard())))
                          .catchError(
                              (error) => print("Failed to add user: $error"));
                    } catch (e) {
                      print(e);
                    }
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

  Future videofromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        uploadFile();
      } else {
        print('No Video selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_video == null) return;
    final fileName = basename(_video!.path);
    final destination = 'videofiles/$fileName';
    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination).child('VideoFile');
      await ref.putFile(_video!);
    } catch (e) {
      print('error occured');
    }
  }

  File? _video;

  final ImagePicker _picker = ImagePicker();
  Future takevideo(BuildContext context) async {
    String fileName = basename(_video!.path);
    final destination = 'videofiles/$fileName';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(destination).child('VideoFile');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'video',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(_video!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      String videoUrl = await (await uploadTask).ref.getDownloadURL();
      print(videoUrl);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'postVideo': videoUrl,
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
                "Choose Video",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.video_file, color: Colors.black),
                  onPressed: () =>
                      {videofromGallery(), Navigator.of(context).pop()},
                  label: Text("Gallery", style: TextStyle(color: Colors.black)),
                ),
              ],
            )
          ]),
    );
  }
}
