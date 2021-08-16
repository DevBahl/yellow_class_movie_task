import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
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

//checking Authentification
  checkAuth() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("onStart");
      }
    });
  }

//getting user
  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

//signing out
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
    /*if (count == 0) {
      this.emptyListWidget();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    if (allMovies == null) {
      allMovies = List<MoviesDetails>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbF6713C),
        elevation: 0.0,
        actions: [
          ButtonTheme(
              minWidth: 50.0,
              height: 80.0,
              buttonColor: Color.fromRGBO(234, 135, 137, 1.0),
              child: Stack(children: [
                NeumorphicButton(
                  onPressed: () {
                    if (viewArrangement == 2) {
                      viewArrangement = 1;
                      setState(() {});
                    } else if (viewArrangement == 1) {
                      viewArrangement = 2;
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
      body: Container(
          color: Color(0xffbF6713C),
          child: !isloggedin ? CircularProgressIndicator() : getNoteListView()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          debugPrint('FAB clicked');
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
                          fontSize: 25.0,
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
                              fontSize: 20.0,
                              fontStyle: FontStyle.normal,
                              color: Colors.white))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        debugPrint("ListTile Tapped");
                        navigateToDetail(
                            this.allMovies[position], 'Edit movie');
                      },
                    ),*/
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Color(0xffbF6713C),
                      ),
                      onTap: () {
                        _delete(context, allMovies[position]);
                      },
                    ),
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
              text:
                  "No watched movies list! Add movies to make a list of your watched playlist",
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

//updating listview
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
}
