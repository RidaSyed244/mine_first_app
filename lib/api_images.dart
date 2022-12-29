import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'navbar.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageScreen extends StatefulWidget {
  static const String id = 'image_screen';
  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {


  List images = [];
  @override
  void initState() {
    super.initState();
    fetchapi();
  
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=25'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001a9fac1dba209474091f0bb33e6973cd8'
        }).then((value) {
      print(value.body);
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  drawer: NavBar(),
       
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            textAlign: TextAlign.center,
            'Dashboard',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (index) => index % 7 == 0
                          ? StaggeredTile.count(2, 2)
                          : StaggeredTile.count(1, 1),
                      itemCount: images.length,
                      crossAxisSpacing: 8,
                      crossAxisCount: 3,
                      mainAxisSpacing: 6,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(images[index]['src']['tiny'],
                              fit: BoxFit.cover),
                        );
                      })),
            ),
          ],
        )));
  }
}
