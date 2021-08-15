import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart';
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

//checking Authentification
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
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
    this.checkAuthentification();
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
        title: Text('Movies'),
        actions: [
          ElevatedButton(
            onPressed: signOut,
            child: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Container(
          child: !isloggedin ? CircularProgressIndicator() : getNoteListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(MoviesDetails('', '', ''), 'Add Movie');
        },
        tooltip: 'Add Movie',
        child: Icon(Icons.add),
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
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Card(
            color: Colors.white,
            elevation: 3.0,
            child: Column(
              children: [
                Container(
                  child: Image(
                    width: 230,
                    height: 200,
                    image: NetworkImage(this.allMovies[position].image),
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      this.allMovies[position].title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(top: 5, left: 5),
                        child: Text(this.allMovies[position].director))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        debugPrint("ListTile Tapped");
                        navigateToDetail(
                            this.allMovies[position], 'Edit movie');
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
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
        return StaggeredTile.count(1, index.isEven ? 1.60 : 1.60);
      },
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
