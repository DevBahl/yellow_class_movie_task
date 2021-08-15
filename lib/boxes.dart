import 'package:hive/hive.dart';
import 'package:yellow_class_movie_task/model/hiveData.dart';

class Boxes{
  static Box<MoviesData> getMoviesData() => 
  Hive.box<MoviesData>('moviesData');
}