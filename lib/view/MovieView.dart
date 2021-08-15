import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yellow_class_movie_task/database.dart';
import 'package:yellow_class_movie_task/model/MoviesDetails.dart';

class MovieView extends StatefulWidget {
  final String appBarTitle;
  final MoviesDetails movie;

  MovieView(this.movie, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return MovieViewState(this.movie, this.appBarTitle);
  }
}

class MovieViewState extends State<MovieView> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  MoviesDetails movie;

  TextEditingController titleController = TextEditingController();
  TextEditingController directorController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  MovieViewState(this.movie, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = movie.title;
    directorController.text = movie.director;
    imageController.text = movie.image;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Movie Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: directorController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDirector();
                    },
                    decoration: InputDecoration(
                        labelText: 'Director Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: imageController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateImage();
                    },
                    decoration: InputDecoration(
                        labelText: 'Set Poster',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
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

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title
  void updateTitle() {
    movie.title = titleController.text;
  }

  // Update the director
  void updateDirector() {
    movie.director = directorController.text;
  }

  void updateImage() {
    movie.image = imageController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    int result;
    if (movie.id != null) {
      // Case 1: Update operation
      result = await helper.updateMovie(movie);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertMovie(movie);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Movie Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Movie');
    }
  }

//deleting the data
  void _delete() async {
    moveToLastScreen();

    if (movie.id == null) {
      _showAlertDialog('Status', 'No Movie was deleted');
      return;
    }

    int result = await helper.deleteMovie(movie.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Movie Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting movie');
    }
  }

//showing dialogbox
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
