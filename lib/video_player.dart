// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

// class VideoPlayerWidget extends StatelessWidget {
//   final VideoPlayerController controller;
//   const VideoPlayerWidget({Key? key, required this.controller})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return controller!=null && controller.value.isInitialized
//     ?Container(child: buildVideo())
//     :Container(height: 200,child: Center(child: CircularProgressIndicator()));
//   }
//   Widget buildVideo()=>buildVideoPlayer();
//   Widget buildVideoPlayer()=>AspectRatio(
//     aspectRatio: controller.value.aspectRatio,
//     child: VideoPlayer(controller));
// }
