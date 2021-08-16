import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yellow_class_movie_task/Utility.dart';
import 'package:yellow_class_movie_task/database.dart';
import 'package:yellow_class_movie_task/model/MoviesDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

class MovieView extends StatefulWidget {
  final String appBarTitle;
  final MoviesDetails movies;

  MovieView(this.movies, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return MovieViewState(this.movies, this.appBarTitle);
  }
}

class MovieViewState extends State<MovieView> {
  File imageFile;
  File _image;
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  MoviesDetails movie;
  Image image;
  TextEditingController titleController = TextEditingController();
  TextEditingController directorController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String imgString;

  MovieViewState(this.movie, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontStyle: FontStyle.normal,
      color: Colors.white,
    );

    titleController.text = movie.title;
    directorController.text = movie.director;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          backgroundColor: Color(0xffbF6713C),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Color(0xffFDCF09),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _image,
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20)),
                              width: 300,
                              height: 300,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Movie',
                      labelStyle: textStyle,
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(
                            color: Color(0xff002A5D), width: 2.0),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: directorController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDirector();
                    },
                    decoration: InputDecoration(
                      labelText: 'Director',
                      labelStyle: textStyle,
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(
                            color: Color(0xff002A5D), width: 2.0),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                /*Container(
                  child: NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {
                        NeumorphicTheme.of(context).themeMode =
                            NeumorphicTheme.isUsingDark(context)
                                ? ThemeMode.light
                                : ThemeMode.dark;
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Toggle Theme",
                        style: TextStyle(color: Colors.white),
                      )),
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.only(
                            left: 65, right: 65, top: 10, bottom: 10),
                        color: Color(0xff002A5D),
                        textColor: Colors.white,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.only(
                            left: 58, right: 58, top: 10, bottom: 10),
                        color: Color(0xff002A5D),
                        textColor: Colors.white,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _imgFromCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      imgString = Utility.base64String(imgFile.readAsBytesSync());
      updateImage();
      imgString = movie.image;
      imageFile = imgFile;
    });

    setState(() {
      _image = imageFile;
      updateImage();
      debugPrint('data: $movie.image');
      debugPrint('data: $imgString');
    });
  }

  _imgFromGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      imgString = Utility.base64String(imgFile.readAsBytesSync());
      debugPrint('checkString: $imgString');
      updateImage();
      imgString = movie.image;
      imageFile = imgFile;
    });

    setState(() {
      _image = imageFile;
      updateImage();
      debugPrint('data: $movie.image');
      debugPrint('data: $imgString');
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    movie.title = titleController.text;
  }

  void updateDirector() {
    movie.director = directorController.text;
  }

  void updateImage() {
    movie.image = imgString;
  }

  void _save() async {
    moveToLastScreen();

    int result;
    if (movie.id != null) {
      result = await helper.updateMovie(movie);
    } else {
      result = await helper.insertMovie(movie);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Movie added to your watched list');
    } else {
      _showAlertDialog('Status', 'Error Occured!');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (movie.id == null) {
      _showAlertDialog('Status', 'No Movie was deleted');
      return;
    }

    int result = await helper.deleteMovie(movie.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Movie Deleted');
    } else {
      _showAlertDialog('Status', 'Error Occured while deleting');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Color(0xffbF6713C),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xff002A5D),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
