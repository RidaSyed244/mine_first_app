import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mine_first_app/post_image.dart';
import 'package:mine_first_app/post_text.dart';
import 'package:mine_first_app/post_video.dart';
import 'navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime currentTime = DateTime.now();
  final _auth = FirebaseAuth.instance.currentUser?.email;
  TextEditingController postText = TextEditingController();
    final TextEditingController postVideoText = TextEditingController();

//to make it apper and disappear
  bool _visible = true;
  void speeddialvisible(bool value) {
    //on tap it will be visible and close
    setState(() {
      _visible = value;
    });
  }

//dont use widget with buildspeeddial it will not work
  buildspeedDial() => SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: Colors.black),
        onOpen: () => print("Open"),
        onClose: () => print("Close"),
        curve: Curves.easeInBack,
        visible: _visible,
        children: [
          SpeedDialChild(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostText())),
              backgroundColor: Colors.cyan,
              child: Icon(Icons.text_fields, color: Colors.white),
              label: "Text",
              labelBackgroundColor: Colors.cyan,
              labelStyle: TextStyle(color: Colors.white)),
          SpeedDialChild(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostImages())),
              backgroundColor: Colors.teal,
              child: Icon(Icons.image, color: Colors.white),
              label: "Image",
              labelBackgroundColor: Colors.teal,
              labelStyle: TextStyle(color: Colors.white)),
          SpeedDialChild(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostVideo())),
              backgroundColor: Colors.purple,
              child: Icon(Icons.video_call_outlined, color: Colors.white),
              label: "Video",
              labelBackgroundColor: Colors.purple,
              labelStyle: TextStyle(color: Colors.white))
        ],
      );
  void getCurrentuser() async {
    try {
      final user = await _auth;
      if (user != null) {
        print("user found");
      }
    } catch (e) {
      print("not user found");
    }
  }

  VideoPlayerController? _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.network(postVideoText.text)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller?.play());
    super.initState();
    getCurrentuser();
  }

//"https://firebasestorage.googleapis.com/v0/b/mine-first-app-de7b2.appspot.com/o/videofiles%2Fimage_picker1899529870940105359.mp4%2FVideoFile?alt=media&token=29383c00-2337-4ed2-a324-138e160c4010"
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = _controller!.value.volume == 0;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _controller!.value.isPlaying
              ? _controller?.pause()
              : _controller?.play();
        },
        child: Scaffold(
            drawer: NavBar(),
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                textAlign: TextAlign.center,
                'Post',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            floatingActionButton: buildspeedDial(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(3, 13, 3, 10),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.grey,
                                      child: NetworkImage(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqQMwq_mZ2I9qpXPhmIeJ5on2jZTavrF65Kw&usqp=CAU") ==
                                              true
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          55)),
                                              width: 100,
                                              height: 100,
                                            )
                                          : CircleAvatar(
                                              radius: 55,
                                              backgroundImage: NetworkImage(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqQMwq_mZ2I9qpXPhmIeJ5on2jZTavrF65Kw&usqp=CAU"),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Rida Syed",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //  SizedBox(height: 5),
                                        Text(
                                          DateFormat()
                                              .add_jm()
                                              .format(currentTime),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 175,
                                    ),
                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.menu,
                                        color: Colors.black,
                                      ),
                                      itemBuilder: (content) => [
                                        PopupMenuItem(
                                          child: Text("Report User"),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Text("Block User"),
                                          value: 2,
                                        ),
                                      ],
                                      onSelected: (int menu) {
                                        if (menu == 1) {
                                          _showpicker(context);
                                        } else if (menu == 2) {}
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SingleChildScrollView(
                                child: Container(
                              child: ReadMoreText(
                                snapshot.data.data()?["postVideoText"],
                                trimLines: 3,
                                textAlign: TextAlign.left,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "Show more",
                                trimExpandedText: "Show less",
                                lessStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                moreStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )),
                            SizedBox(
                              height: 3,
                            ),
                            Stack(alignment: Alignment.bottomRight, children: [
                              Container(
                                child: _controller!.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            _controller!.value.aspectRatio,
                                        child: VideoPlayer(_controller!),
                                      )
                                    : Container(
                                        child: Text(
                                          "No Video",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                      ),
                              ),
                              if (_controller != null &&
                                  _controller!.value.isInitialized)
                                IconButton(
                                  icon: Icon(
                                    isMuted
                                        ? Icons.volume_mute
                                        : Icons.volume_up,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () =>
                                      _controller?.setVolume(isMuted ? 1 : 0),
                                ),
                              _controller!.value.isPlaying
                                  ? Container()
                                  : Container(
                                      alignment: Alignment.bottomLeft,
                                      color: Colors.black26,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 50,
                                      )),
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    LikeButton(
                                      size: 24,
                                      circleColor: CircleColor(
                                          start: Colors.black,
                                          end: Color(0xff0099cc)),
                                      bubblesColor: BubblesColor(
                                        dotPrimaryColor: Color(0xff33b5e5),
                                        dotSecondaryColor: Color(0xff0099cc),
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.thumb_up,
                                          color: isLiked
                                              ? Colors.blue
                                              : Colors.black,
                                          size: 24,
                                        );
                                      },
                                      likeCount: likeCount.length,
                                      countBuilder: (count, isLiked, text) {
                                        var color = isLiked
                                            ? Colors.deepPurpleAccent
                                            : Colors.grey;
                                        Widget result;
                                        if (count == 0) {
                                          result = Text(
                                            "Like",
                                            style: TextStyle(color: color),
                                          );
                                        } else
                                          result = Text(
                                            text,
                                            style: TextStyle(color: color),
                                          );
                                        return result;
                                      },
                                      onTap: onLikeButtonTapped,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'Comments',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
                  } else {
                    return SpinKitSpinningLines(
                        size: 100, color: Color(0xFF25315B));
                  }
                })));
  }

  void _showpicker(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: ((builder) => _mySheet(context)));
  }

  _mySheet(BuildContext context) {
    return Container(
        child: Wrap(
      children: [
        new ListTile(
          title: Text(
            "Why are you reporting this post?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        new ListTile(
          title: Text(
            "I just don't like it",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
        new ListTile(
          title: Text(
            "It's a spam",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
        new ListTile(
          title: Text(
            "Scam or fraud",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
        new ListTile(
          title: Text(
            "Violence",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
        new ListTile(
          title: Text(
            "False information",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
        new ListTile(
          title: Text(
            "Illegal material",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
        new ListTile(
          title: Text(
            "Something else",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          onTap: () => OpenDilog(),
        ),
      ],
    ));
  }

  Future OpenDilog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Thanks for letting us know",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "We use your report to show you less of this kind of content in the future...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          actions: [
            TextButton(
                onPressed: submit,
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ))
          ],
        ),
      );
  void submit() {
    Navigator.of(context).pop();
  }

  List likeCount = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"likesCount": likeCount});

    return !isLiked;
  }

// height:
//     MediaQuery.of(context).size.width - 50,
// decoration: BoxDecoration(
//   boxShadow: [
//     BoxShadow(
//       color: Colors.black.withOpacity(0.3),
//     )
//   ],
// ),

}
