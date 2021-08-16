import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:yellow_class_movie_task/model/MoviesDetails.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String movieTable = 'movies';
  String colId = 'id';
  String colTitle = 'title';
  String colDirector = 'director';
  String colImage = 'image';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'movies.db';

    var moviesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return moviesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $movieTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDirector TEXT, $colImage TEXT)');
  }

  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database db = await this.database;

    var result = await db.query(movieTable);
    return result;
  }

  Future<int> insertMovie(MoviesDetails note) async {
    Database db = await this.database;
    var result = await db.insert(movieTable, note.toMap());
    return result;
  }

  Future<int> updateMovie(MoviesDetails movie) async {
    var db = await this.database;
    var result = await db.update(movieTable, movie.toMap(),
        where: '$colId = ?', whereArgs: [movie.id]);
    return result;
  }

  Future<int> deleteMovie(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $movieTable WHERE $colId = $id');
    return result;
  }

  Future<List<MoviesDetails>> getMovieList() async {
    var movieMapList = await getMovieMapList();
    int count = movieMapList.length;

    List<MoviesDetails> movieList = List<MoviesDetails>();

    for (int i = 0; i < count; i++) {
      movieList.add(MoviesDetails.fromMapObject(movieMapList[i]));
    }

    return movieList;
  }
}
