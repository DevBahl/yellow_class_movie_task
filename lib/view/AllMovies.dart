import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yellow_class_movie_task/Utility.dart';
import 'package:yellow_class_movie_task/database.dart';
import 'package:yellow_class_movie_task/model/MoviesDetails.dart';
import 'package:yellow_class_movie_task/view/MovieView.dart';

class AllMovies extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllMoviesState();
  }
}

class AllMoviesState extends State<AllMovies> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<MoviesDetails> allMovies;
  int count = 0;
  int viewArrangement = 2;

  double fontSize1 = 25;
  double fontSize2 = 20;
  double leftSize = 70;
  double rightSize = 70;

  checkAuth() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("onStart");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
        if (count == 0) {
          _showAlertDialog();
        }
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuth();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (allMovies == null) {
      allMovies = List<MoviesDetails>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffbF6713C),
        elevation: 0.0,
        actions: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 10),
            child: RichText(
                text: TextSpan(
                    text: 'YCM',
                    style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontStyle: FontStyle.italic,
                        color: Color(0xff002A5D)))),
          ),
          Container(
            margin: EdgeInsets.only(right: 50),
            child: Icon(
              Icons.movie,
              color: Color(0xff002A5D),
            ),
          ),
          ButtonTheme(
              minWidth: 50.0,
              height: 80.0,
              buttonColor: Color.fromRGBO(234, 135, 137, 1.0),
              child: Stack(children: [
                NeumorphicButton(
                  onPressed: () {
                    if (viewArrangement == 2) {
                      viewArrangement = 1;
                      fontSize1 = 15.0;
                      fontSize2 = 10.0;
                      leftSize = 10.0;
                      rightSize = 10.0;
                      setState(() {});
                    } else if (viewArrangement == 1) {
                      viewArrangement = 2;
                      fontSize1 = 25.0;
                      fontSize2 = 20.0;
                      leftSize = 70.0;
                      rightSize = 70.0;
                      setState(() {});
                    }
                  },
                  child: Text(
                    "Change View",
                    style: TextStyle(color: Color(0xff002A5D)),
                  ),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  margin: EdgeInsets.only(top: 10, right: 10),
                ),
              ])),
          NeumorphicButton(
            onPressed: () {
              signOut();
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Color(0xff002A5D)),
            ),
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
            ),
            padding: const EdgeInsets.all(12.0),
            margin: EdgeInsets.only(top: 10, right: 10, bottom: 5),
          ),
        ],
      ),
      body: Container(color: Color(0xffbF6713C), child: getNoteListView()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          navigateToDetail(MoviesDetails('', '', ''), 'Add Movie');
        },
        tooltip: 'Add Movie',
        child: Icon(
          Icons.add,
          color: Color(0xffbF6713C),
        ),
      ),
    );
  }

  StaggeredGridView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return StaggeredGridView.countBuilder(
      itemCount: count,
      crossAxisSpacing: 2,
      mainAxisSpacing: 12,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            shadowColor: Colors.black,
            color: Color(0xff002A5D),
            elevation: 8.0,
            child: Column(
              children: [
                Container(
                  //borderRadius: BorderRadius.circular(25.0),
                  child: Ink.image(
                      height: 200,
                      image: Utility.imageFromBase64String(
                              this.allMovies[position].image)
                          .image,
                      fit: BoxFit.cover,
                      child: InkWell(
                        onTap: () {
                          navigateToDetail(
                              this.allMovies[position], 'Edit movie');
                        },
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 5),
                    child: Text(
                      this.allMovies[position].title,
                      style: GoogleFonts.poppins(
                          fontSize: fontSize1,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: EdgeInsets.only(top: 0, left: 5),
                      child: Text(this.allMovies[position].director,
                          style: GoogleFonts.poppins(
                              fontSize: fontSize2,
                              fontStyle: FontStyle.normal,
                              color: Colors.white))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        padding: EdgeInsets.only(
                            left: leftSize,
                            right: rightSize,
                            top: 10,
                            bottom: 10),
                        child: Text('Delete',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontStyle: FontStyle.normal)),
                        color: Color(0xffbF6713C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                          _delete(context, allMovies[position]);
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
      crossAxisCount: 2,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(viewArrangement, index.isEven ? 1.80 : 1.80);
      },
    );
  }

  Widget emptyListWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 400,
            child: SvgPicture.asset('assets/icons/empty.svg',
                height: 200.0, width: 200.0),
          ),
          RichText(
            text: TextSpan(
              text: "No watched movies!Add movies to your list",
              style: GoogleFonts.poppins(
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal,
                  color: Color(0xff002A5D)),
            ),
          ),
        ],
      ),
    );
  }

  void _delete(BuildContext context, MoviesDetails note) async {
    int result = await databaseHelper.deleteMovie(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Movie Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(MoviesDetails movie, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieView(movie, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MoviesDetails>> movieListFuture =
          databaseHelper.getMovieList();
      movieListFuture.then((allMovies) {
        setState(() {
          this.allMovies = allMovies;
          this.count = allMovies.length;
        });
      });
    });
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Color(0xff002A5D),
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
                      "No watched movies? Add movies to your list now!",
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
                        color: const Color(0xffbF6713C),
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
